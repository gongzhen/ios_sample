//
//  ImageCache.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WebimageCompat.h" /// importing macro DispatchQueueSetterSementics strong

#import "ImageCacheConfig.h" /// import config

typedef NS_ENUM(NSInteger, ImageCacheType) {
    ImageCacheTypeNone,
    
    ImageCacheTypeDisk,
    
    ImageCacheTypeMemory
};

typedef void (^CacheQueryCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, ImageCacheType cacheType);

@interface ImageCache : NSObject

@property(nonatomic, nonnull, readonly) ImageCacheConfig *config;

/// Return global shared imageCache
+ (nonnull instancetype)sharedImageCache;

#pragma mark - Query and Retrieve Ops

/// Check cache
- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key done:(nullable CacheQueryCompletedBlock)doneBlock;
    
/// Query the memorhy cache synchronously.
- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key;
    
#pragma mark - Store Ops

- (void)storeImage:(nullable UIImage *)image
            forKey:(nullable NSString *)key
        completion:(nullable WebImageNoParamsBlock)completionBlock;
    
- (void)storeImage:(nullable UIImage *)image
            forKey:(nullable NSString *)key
            toDisk:(BOOL)toDisk
            completion:(nullable WebImageNoParamsBlock)completionBlock;
    
- (void)storeImage:(nullable  UIImage *)image imageData:(nullable NSData *)imageData
            forKey:(nullable  NSString *)key
            toDisk:(BOOL)toDisk
        completion:(nullable  WebImageNoParamsBlock)completionBlock;

@end
