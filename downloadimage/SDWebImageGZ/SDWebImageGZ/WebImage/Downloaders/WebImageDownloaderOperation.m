//
//  WebImageDownloaderOperation.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "WebImageDownloaderOperation.h"
#import "WebimageCompat.h"


typedef NSMutableDictionary<NSString *, id> CallbacksDictionary;

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface WebImageDownloaderOperation()

@property (strong, nonatomic, nonnull) NSMutableArray<CallbacksDictionary *> *callbackBlocks;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;

@property (assign, nonatomic, getter = isFinished) BOOL finished;

@property (strong, nonatomic, nullable) NSMutableData *imageData;


@property (weak, nonatomic, nullable) NSURLSession *unownedSession;

@property (strong, nonatomic, nullable) NSURLSession *ownedSession;

@property (strong, nonatomic, readwrite, nullable) NSURLSessionTask *dataTask;

@property (DispatchQueueSetterSementics, nonatomic, nullable) dispatch_queue_t barrierQueue;

@end

@implementation WebImageDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (nonnull instancetype)init {
    
    return [self initWithRequest:nil inSession:nil];
}

- (nonnull instancetype) initWithRequest:(nullable NSURLRequest *)request
                               inSession:(nullable NSURLSession *)session {
    if ((self = [super init])) {
        _request = [request copy];
        _shouldDecompressImages = YES;
        _callbackBlocks = [NSMutableArray new];
        _executing = NO;
        _finished = NO;
        _expectedSize = 0;
        _barrierQueue = dispatch_queue_create("com.gongzhen.ObjCApp.WebImageDownloaderOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)dealloc {
    DispatchQueueRelease(_barrierQueue);
}

- (nullable id)addHandlersForProgress:(nullable WebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable WebImageDownloaderCompletedBlock)completedBlock {
    CallbacksDictionary *callbacks = [NSMutableDictionary new];
    if (progressBlock) {
        callbacks[kProgressCallbackKey] = [progressBlock copy];
    }
    if (completedBlock) {
        callbacks[kCompletedCallbackKey] = [completedBlock copy];
    }
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callbackBlocks addObject:callbacks];
    });
    return callbacks;
}

- (nullable NSArray<id> *)callbacksForKey:(NSString *)key {
    __block NSMutableArray<id> *callbacks = nil;
    dispatch_sync(self.barrierQueue, ^{
        // We need to remove [NSNull null] because there might not always be a progress block for each callback
        callbacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
        [callbacks removeObjectIdenticalTo:[NSNull null]];
    });
    return [callbacks copy];    // strip mutability here
}


- (BOOL)cancel:(nullable id)token {
    __block BOOL shouldCancel = NO;
    dispatch_barrier_sync(self.barrierQueue, ^{
        /// todo
    });
    
    return shouldCancel;
}

- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self start];
            return;
        }
        
        /// todo: UIKIT
        
        NSURLSession *session = self.unownedSession;
        if(!self.unownedSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 15;
            
            self.ownedSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            session = self.ownedSession;
        }
        
        self.dataTask = [session dataTaskWithRequest:self.request];
        self.executing = YES;
    }
    
    [self.dataTask resume];
    
    /// todo
    
}

- (void)cancel {
    @synchronized (self) {
        
    }
}

- (void)cancelInternal {
    if (self.isFinished) {
        return;
    }
    
    [super cancel];
    
    if(self.dataTask) {
        [self.dataTask cancel];
        
        /// todo
    }
    
    [self reset];

}

- (void) reset {
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
    });
    self.dataTask = nil;
    self.imageData = nil;
    if(self.ownedSession) {
        [self.ownedSession invalidateAndCancel];
        self.ownedSession = nil;
    }
}

- (void) done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    //'304 Not Modified' is an exceptional one
    if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode < 400 && ((NSHTTPURLResponse *)response).statusCode != 304)) {
        NSInteger expected = (NSInteger)response.expectedContentLength;
        expected = expected > 0 ? expected : 0;
        self.expectedSize = expected;
        for (WebImageDownloaderProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(0, expected, self.request.URL);
        }
        
        self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
        self.response = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            /// [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadReceiveResponseNotification object:self];
        });
    } else {
        NSUInteger code = ((NSHTTPURLResponse *)response).statusCode;
        
        //This is the case when server returns '304 Not Modified'. It means that remote image is not changed.
        //In case of 304 we need just cancel the operation and return cached image from the cache.
        if (code == 304) {
            [self cancelInternal];
        } else {
            [self.dataTask cancel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            /// [[NSNotificationCenter defaultCenter] postNotificationName:WebImageDownloadStopNotification object:self];
        });
        
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:((NSHTTPURLResponse *)response).statusCode userInfo:nil]];
        
        [self done];
    
    }
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
 
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
}
 
#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    

}
 
#pragma mark Helper methods

- (void)callCompletionBlocksWithError:(nullable NSError *)error {
    [self callCompletionBlocksWithImage:nil imageData:nil error:error finished:YES];
}

- (void)callCompletionBlocksWithImage:(nullable UIImage *)image
                            imageData:(nullable NSData *)imageData
                                error:(nullable NSError *)error
                             finished:(BOOL)finished {
    NSArray<id> *completionBlocks = [self callbacksForKey:kCompletedCallbackKey];
    dispatch_main_async_safe(^{
        for (WebImageDownloaderCompletedBlock completedBlock in completionBlocks) {
            completedBlock(image, imageData, error, finished);
        }
    });
}

@end
