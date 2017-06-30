//
//  WebImageDownloader.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "WebImageDownloader.h"
#import "WebImageDownloaderOperation.h"

@implementation WebImageDownloadToken

@end

@interface WebImageDownloader()

@property (assign, nonatomic, nullable) Class operationClass;

@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;

@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, WebImageDownloaderOperation *> *URLOperations;
@property(strong, nonatomic, nullable) HTTPHeadersMutableDictionary *HTTPHeaders;

/// Serializing the handling of network response of all download operation.
@property (DispatchQueueSetterSementics, nonatomic, nullable) dispatch_queue_t barrierQueue;

@property(strong, nonatomic) NSURLSession *session;

@end

@implementation WebImageDownloader

+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

+ (void)initialize {
    
}

- (nonnull instancetype)init {
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}


- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration {
    if ((self = [super init])) {
        _operationClass = [WebImageDownloaderOperation class];
        _shouldDecompressImages = YES;
        _barrierQueue = dispatch_queue_create("com.gongzhen.ObjCApp.WebImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _downloadQueue.name = @"com.gongzhen.ObjCApp.WebImageDownloader";
        _downloadTimeout = 15.0;
        
        _URLOperations = [NSMutableDictionary new];
    }
    return self;
}

- (nullable WebImageDownloadToken *)downloadImageWithURL:(nullable NSURL *)url
                                                progress:(nullable WebImageDownloaderProgressBlock)progressBlock
                                               completed:(nullable WebImageDownloaderCompletedBlock)completedBlock {
    __weak WebImageDownloader *wself = self;
    
    return [self addProgressCallback:progressBlock completedBlock:completedBlock forURL:url creatCallback:^WebImageDownloaderOperation *{
        __strong __typeof(wself) sself = wself;
        NSTimeInterval timeoutInterval = sself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }
        
        NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
        /// todo SDWebImageDownloaderUseNSURLCache
        cachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
        
        /// todo request.HTTPShouldHandleCookies
        request.HTTPShouldUsePipelining = YES;
        
        if(sself.headersFilter) {
            request.allHTTPHeaderFields = sself.headersFilter(url, [sself.HTTPHeaders copy]);
        } else {
            request.allHTTPHeaderFields = sself.HTTPHeaders;
        }
        
        WebImageDownloaderOperation *operation = [[sself.operationClass alloc] initWithRequest:request inSession:sself.session];
        
        operation.shouldDecompressImages = sself.shouldDecompressImages;
        
        /// todo sself.urlCredential
        
        [sself.downloadQueue addOperation:operation];
        
        return operation;
    }];
}

/// downloaderOperation in WebImageManager called cancel.
- (void)cancel:(nullable WebImageDownloadToken *)token {
    dispatch_barrier_async(self.barrierQueue, ^{
        WebImageDownloaderOperation *operation = self.URLOperations[token.url];
        BOOL canceled = [operation cancel:token.downloadOperationCancelToken];
        if(canceled) {
            [self.URLOperations removeObjectForKey:token.url];
        }
    });
}

- (nullable WebImageDownloadToken *)addProgressCallback:(WebImageDownloaderProgressBlock)progressBlock
                                         completedBlock:(WebImageDownloaderCompletedBlock)completedBlock
                                                 forURL:(nullable NSURL *)url
                                          creatCallback:(WebImageDownloaderOperation *(^)())createCallback {
    if (url == nil) {
        if(completedBlock != nil) {
            completedBlock(nil, nil, nil, NO);
        }
        return nil;
    }
    
    __block WebImageDownloadToken *token = nil;
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        WebImageDownloaderOperation *operation = self.URLOperations[url];
        if(!operation) {
            operation = createCallback();
            self.URLOperations[url] = operation;
            __weak WebImageDownloaderOperation *woperation = operation;
            operation.completionBlock = ^{
                WebImageDownloaderOperation *soperation = woperation;
                if (!soperation) return;
                if (self.URLOperations[url] == soperation) {
                    [self.URLOperations removeObjectForKey:url];
                };
            };
        }
        id downloadOperationCancelToken = [operation addHandlersForProgress:progressBlock completed:completedBlock];
        
        token = [WebImageDownloadToken new];
        token.url = url;
        token.downloadOperationCancelToken = downloadOperationCancelToken;
    });
    return token;
}

@end
