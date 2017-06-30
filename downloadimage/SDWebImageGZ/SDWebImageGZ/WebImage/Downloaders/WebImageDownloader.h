//
//  WebImageDownloader.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WebimageCompat.h" /// import DispatchQueueSetterSementics

typedef void (^WebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);

typedef void (^WebImageDownloaderCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished);


typedef NSDictionary<NSString *, NSString *> HTTPHeadersDictionary;
typedef NSMutableDictionary<NSString *, NSString*> HTTPHeadersMutableDictionary;

typedef HTTPHeadersDictionary * _Nullable (^WebImageDownloaderHeadersFilterBlock)(NSURL * _Nullable url, HTTPHeadersDictionary * _Nullable headers);

@interface WebImageDownloadToken : NSObject

@property (nonatomic, strong, nullable) NSURL *url;
@property (nonatomic, strong, nullable) id downloadOperationCancelToken;

@end

@interface WebImageDownloader : NSObject

@property (assign, nonatomic) BOOL shouldDecompressImages;

@property (assign, nonatomic) NSInteger maxConcurrentDownloads;
    
@property (readonly, nonatomic) NSUInteger currentDownloadCount;

@property (assign, nonatomic) NSTimeInterval downloadTimeout;

@property (nonatomic, copy, nullable) WebImageDownloaderHeadersFilterBlock headersFilter;

- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration;

/// return global shared downLoader.
+ (nonnull instancetype)sharedDownloader;

- (nullable WebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                progress:(nullable WebImageDownloaderProgressBlock)progressBlock
                                                completed:(nullable WebImageDownloaderCompletedBlock)completedBlock;

- (void)cancel:(nullable WebImageDownloadToken *)token;

@end
