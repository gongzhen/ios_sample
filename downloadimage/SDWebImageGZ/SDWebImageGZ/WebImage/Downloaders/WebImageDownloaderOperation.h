//
//  WebImageDownloaderOperation.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebImageDownloader.h"  /// import WebImageDownloaderProgressBlock
#import "WebimageCompat.h" /// DispachQeueueRelease

#import "WebImageOperation.h" /// import Protocol SDWebImageOperation method: cancel

@protocol WebImageDownloaderOperationInterface <NSObject>

- (nullable id)addHandlersForProgress:(nullable WebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable WebImageDownloaderCompletedBlock)completedBlock;

@end

@interface WebImageDownloaderOperation : NSOperation <WebImageDownloaderOperationInterface, WebImageOperation, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic, readonly, nullable) NSURLRequest *request;

@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;

@property (assign, nonatomic) BOOL shouldDecompressImages;

@property (nonatomic, strong, nullable) NSURLCredential *credential;

/// todo: options

@property (assign, nonatomic) NSInteger expectedSize;

@property (strong, nonatomic, nullable) NSURLResponse *response;

- (nonnull instancetype) initWithRequest:(nullable NSURLRequest *)request
                               inSession:(nullable NSURLSession *)session NS_DESIGNATED_INITIALIZER;

- (nullable id)addHandlersForProgress:(nullable WebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable WebImageDownloaderCompletedBlock)completedBlock;

- (BOOL)cancel:(nullable id)token;

@end
