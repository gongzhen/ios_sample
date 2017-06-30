//
//  ImageCache.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ImageCache.h"
#import "UIImage+GIF.h"

#import <CommonCrypto/CommonDigest.h> /// CC_MD5_DIGEST_LENGTH

/// https://github.com/rs/SDWebImage/pull/1141: LRU cache
@interface AutoPurgeCache: NSCache

@end

@implementation AutoPurgeCache

- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        /// self.memCache will remove all objects when receving memory warning notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

@end

FOUNDATION_STATIC_INLINE NSUInteger CacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}

@interface ImageCache()

@property(strong, nonatomic, nonnull) NSCache *memCache;
@property(strong, nonatomic, nonnull) NSString *diskCachePath; /// Searching cache from all the keys.
@property(strong, nonatomic, nonnull) NSMutableArray<NSString *> *customPaths; /// copy to NSArray*
@property(DispatchQueueSetterSementics, nonatomic, nullable) dispatch_queue_t ioQueue;

@end

@implementation ImageCache {
    NSFileManager *_fileManager;
}

#pragma mark - Singleton, init, dealloc

+ (nonnull instancetype)sharedImageCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
       instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    return [self initWithNamespace:@"default"];
}

- (nonnull instancetype) initWithNamespace:(nonnull NSString *)ns {
    NSString *path = [self makeDiskCachePath:ns];
    return [self initWithNamespace:ns diskCacheDirectory:path];
}

- (nonnull instancetype) initWithNamespace:(nonnull NSString *)ns diskCacheDirectory:(nonnull NSString *)directory {
    if ((self = [super init])) {
        NSString *fullNamespace = [@"com.gongzhen.ObjCApp.SDWebImageGZ." stringByAppendingString:ns];
        _ioQueue = dispatch_queue_create("com.gongzhen.ObjCApp.SDWebImageGZ", DISPATCH_QUEUE_SERIAL);
        
        /// kDefaultCacheMaxCacheAge is in ImageCacheConfig class.
        _config = [[ImageCacheConfig alloc] init];
        
        _memCache.name = fullNamespace;
        
        if (directory != nil) {
            _diskCachePath = [directory stringByAppendingPathComponent:fullNamespace];
        } else {
            NSString *path = [self makeDiskCachePath:ns];
            _diskCachePath = path;
        }
        
        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
        
        /// SD_UIKIT
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteOldFiles) name:UIApplicationWillTerminateNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundDeleteOldFiles) name:UIApplicationDidEnterBackgroundNotification object:nil];
        /// Posted when the app enters the background
    }
    return self;
}

#pragma mark - Store Ops

- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
                completion:(WebImageNoParamsBlock)completionBlock {
    [self storeImage:image imageData:nil forKey:key toDisk:YES completion:completionBlock];
}

- (void)storeImage:(UIImage *)image
            forKey:(NSString *)key
            toDisk:(BOOL)toDisk
            completion:(WebImageNoParamsBlock)completionBlock {
    [self storeImage:image imageData:nil forKey:key toDisk:toDisk completion:completionBlock];
}

- (void)storeImage:(UIImage *)image
         imageData:(NSData *)imageData
            forKey:(NSString *)key
            toDisk:(BOOL)toDisk
            completion:(WebImageNoParamsBlock)completionBlock {
    if(!image || !key) {
        if(completionBlock) {
            completionBlock();
        }
        return;
    }
    
    if(self.config.shouldCacheImagesInMemory) {
        NSUInteger cost = CacheCostForImage(image);
        [self.memCache setObject:image forKey:key cost:cost];
    }
    
    if(toDisk) {
        dispatch_async(self.ioQueue, ^{
            @autoreleasepool {
                NSData *data = imageData;
                if(!data && image) {
                    /// todo sd_imageDataAsFormat
                }
                
                [self storeImageDataToDisk:data forKey:key];
            }
            
            if(completionBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock();
                });
            }
        });
    } else {
        if(completionBlock) {
            completionBlock();
        }
    }
}

- (void)storeImageDataToDisk:(nullable NSData *)imageData forKey:(nullable NSString *)key {
    if(!imageData || !key) {
        return;
    }
    
    /// todo store image to disk.
}

#pragma mark - Query and Retrieve Ops

- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key done:(nullable CacheQueryCompletedBlock)doneBlock {
    
    /// Look for image from memory cache.
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    
    if (image) {
        
        NSData *diskData = nil;
        if([image isGIF]) {
            /// Search diskData by key
            diskData = [self diskImageDataBySearchingAllPathsForKey:key];
        }
        /// ImageCacheType is memory.
        if(doneBlock) {
            doneBlock(image, diskData, ImageCacheTypeMemory);
        }
        return nil;
    }
    
    /// Look for cache from disk.
    NSOperation *operation = [NSOperation new];
    dispatch_async(self.ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        @autoreleasepool {
            NSData *diskData = [self diskImageDataBySearchingAllPathsForKey:key];
            UIImage *diskImage = [self diskImageForKey:key];
            if (diskImage && self.config.shouldCacheImagesInMemory) {
                /// todo: NSUInteger cost = CacheCostForImage(diskImage)
                [self.memCache setObject:diskImage forKey:key cost:0];
            }
            
            if (doneBlock) {
                doneBlock(image, diskData, ImageCacheTypeDisk);
            }
        }
    });
    
    return operation;
}

- (nullable UIImage *)diskImageForKey:(nullable NSString *)key {
    NSData *data = [self diskImageDataBySearchingAllPathsForKey:key];
    if (data) {
        /// todo: UIImage sd_imageWithData:data
        UIImage *image = [UIImage imageWithData:data];
        // todo: image = [self scaledImageForKey:key image:image];
        if (self.config.shouldDecompressImages) {
            /// todo: image = [UIImage decodeImageWithImage:image]
        }
        return image;
    } else {
        return nil;
    }
}

/// Search image from memory cache.
- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key {
    return [self.memCache objectForKey:key];
}

/// Search diskData by key
- (nullable NSData *)diskImageDataBySearchingAllPathsForKey:(nullable NSString *)key {
    NSString *defaultPath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }
    
    data = [NSData dataWithContentsOfFile:defaultPath.stringByDeletingPathExtension];
    
    if (data) {
        return data;
    }
    
    NSArray<NSString *> *customPaths = [self.customPaths copy];
    for (NSString *path in customPaths) {
        NSString *filePath = [self cachePathForKey:key inPath:path];
        NSData* imageData = [NSData dataWithContentsOfFile:filePath];
        if(imageData) {
            return imageData;
        }
        
        imageData = [NSData dataWithContentsOfFile:filePath.stringByDeletingPathExtension];
        if(imageData) {
            return imageData;
        }
    }
    
    return nil;
}

#pragma mark - Cache paths

- (nullable NSString *)cachePathForKey:(nullable NSString *)key inPath:(nonnull NSString *)path {
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}

- (nullable NSString *)defaultCachePathForKey:(nullable NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension]];
    
    return filename;
}

    
- (nullable NSString *)makeDiskCachePath:(nonnull NSString *)fullNamespace {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

#pragma mark - Cache clean Ops

- (void)clearMemory {
    [self.memCache removeAllObjects];
}

- (void)deleteOldFiles {
    [self deleteOldFilesWithCompletionBlock:nil];
}

- (void)deleteOldFilesWithCompletionBlock:(void(^)())completionBlock {

}

- (void)backgroundDeleteOldFiles {
    
}

@end
