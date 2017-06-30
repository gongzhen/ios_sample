//
//  WebImageManager.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ImageCache.h" // cacheType
#import "WebImageDownloader.h" /// WebImageDownloaderProgressBlock
#import "WebImageOperation.h" /// import WebImageOperation
#import "WebimageCompat.h" /// WebImageNoParamsBlock

typedef void (^ExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, ImageCacheType cacheType, NSURL * _Nullable imageURL);

typedef void (^InternalCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, ImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL);

typedef NSString * _Nullable (^WebImageCacheKeyFilterBlock)(NSURL * _Nullable url);

@class WebImageManager;

@protocol WebImageManagerDelegate <NSObject>

@optional

- (BOOL)imageManager:(nonnull WebImageManager *)imageManager shouldDownloadImageForURL:(nullable NSURL *)imageURL;

- (nullable UIImage *)imageManager:(nonnull WebImageManager *)imageManager transformDownloaderImage:(nullable UIImage *)image withURL:(nullable NSURL *)imageURL;

@end

@interface WebImageManager : NSObject

@property (weak, nonatomic, nullable) id<WebImageManagerDelegate> delegate;

@property (strong, nonatomic, readonly, nullable) ImageCache *imageCache;
@property (strong, nonatomic, readonly, nullable) WebImageDownloader *imageDownloader;

@property (nonatomic, copy, nullable) WebImageCacheKeyFilterBlock cacheKeyFilter;

+ (nonnull instancetype)sharedManager; /// singleton manager

- (nonnull instancetype)initWithCache:(nonnull ImageCache *)cache
                           downloader:(nonnull WebImageDownloader *)downloader NS_DESIGNATED_INITIALIZER;

- (nullable id<WebImageOperation>)loadImageWithURL:(nullable NSURL *)url
                                          progress:(nullable WebImageDownloaderProgressBlock)progressBlock
                                         completed:(nullable InternalCompletionBlock)completedBlock;
    

@end
