//
//  WebImageManager.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "WebImageManager.h"

@interface WebImageCombinedOperation : NSObject <WebImageOperation>

@property (assign, nonatomic, getter=isCancelled) BOOL cancelled;
@property (copy, nonatomic, nullable) WebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic, nullable) NSOperation *cacheOperation;

@end


@interface WebImageManager()

@property(strong, nonatomic, readwrite, nonnull) ImageCache *imageCache;
@property(strong, nonatomic, readwrite, nonnull) WebImageDownloader *imageDownloader;

@property(strong, nonatomic, nonnull)NSMutableArray<WebImageCombinedOperation *> *runningOperations;
    
@end

@implementation WebImageManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    ImageCache *cache = [ImageCache sharedImageCache];
    WebImageDownloader *downloader = [WebImageDownloader sharedDownloader];
    return [self initWithCache:cache downloader:downloader];
}

- (nonnull instancetype)initWithCache:(nonnull ImageCache *)cache
                           downloader:(nonnull WebImageDownloader *)downloader {
    if (self = [super init]) {
        _imageCache = cache;
        _imageDownloader = downloader;
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url {
    if(!url) {
        return @"";
    }
    
    if (self.cacheKeyFilter) {
        self.cacheKeyFilter(url);
    }
    return url.absoluteString;
}

/// loadImageWithURL return id objet that comforms WebImageOperation protocol.
- (nullable id<WebImageOperation>)loadImageWithURL:(nullable NSURL *)url
                                          progress:(nullable WebImageDownloaderProgressBlock)progressBlock
                                         completed:(nullable InternalCompletionBlock)completedBlock {
    
    __block WebImageCombinedOperation *operation = [WebImageCombinedOperation new];
    __weak WebImageCombinedOperation *weakOperation = operation;
    
    NSString *key = [self cacheKeyForURL:url];
    
    /// todo check failedUrl
    
    operation.cacheOperation = [self.imageCache queryCacheOperationForKey:key done:^(UIImage * _Nullable cachedImage, NSData * _Nullable cachedData, ImageCacheType cacheType) {
        /// todo: check operation is cancelled.
        
        
        // Record the token. operation can be cancelled via token.
        WebImageDownloadToken *subOperationToken = [self.imageDownloader downloadImageWithURL:url
                                                                                     progress:progressBlock
                                                                                    completed:^(UIImage * _Nullable downloadImage,
                                                                                                NSData * _Nullable downloadData,
                                                                                                NSError * _Nullable error,
                                                                                                BOOL finished) {
            __strong __typeof(weakOperation) strongOperation = weakOperation;
            
            if (!strongOperation || strongOperation.isCancelled) {
            
            } else if (error) {
                
            } else {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    UIImage *transformedImage = [self.delegate imageManager:self transformDownloaderImage:downloadImage withURL:url];
                    
                    /// todo: finished
                    if (transformedImage) {
                        /// todo
                        [self.imageCache storeImage:transformedImage imageData:downloadData forKey:key toDisk:YES completion:nil];
                    }
                    
                    [self callCompletionBlockForOperation:strongOperation completion:completedBlock image:transformedImage data:downloadData error:nil cacheType:ImageCacheTypeNone finished:YES url:url];
                });
            }
            
            if(finished) {
                [self safelyRemoveOperationFromRunning:strongOperation];
            }
        }];
        /// todo cachedImage
        operation.cancelBlock = ^{
            [self.imageDownloader cancel:subOperationToken];
        };
    }];
    
    return operation;
}

- (void)callCompletionBlockForOperation:(nullable WebImageCombinedOperation *)operation
                            completion:(nullable InternalCompletionBlock)completionBlock
                                 error:(nullable NSError *)error
                                 url:(nullable NSURL *)url {
    [self callCompletionBlockForOperation:operation
                               completion:completionBlock
                                    image:nil
                                     data:nil
                                    error:error
                                cacheType:ImageCacheTypeNone
                                 finished:YES
                                      url:url];
}

- (void)callCompletionBlockForOperation:(nullable WebImageCombinedOperation *)operation
                             completion:(nullable InternalCompletionBlock)completionBlock
                                  image:(nullable UIImage *)image
                                  data:(nullable NSData *)data
                                  error:(nullable NSError *)error
                              cacheType:(ImageCacheType)cacheType
                              finished:(BOOL)finished
                              url:(nullable NSURL *)url {
    dispatch_main_async_safe(^{
        if(operation && !operation.isCancelled && completionBlock) {
            completionBlock(image, data, error, cacheType, finished, url);
        }
    });
}

- (void)safelyRemoveOperationFromRunning:(nullable WebImageCombinedOperation *)operation {
    @synchronized (self.runningOperations) {
        if(operation) {
            [self.runningOperations removeObject:operation];
        }
    }
}

@end

@implementation WebImageCombinedOperation

- (void)setCancelBlock:(nullable WebImageNoParamsBlock)cancelBlock {
    
}

- (void)cancel {
    
}

@end


