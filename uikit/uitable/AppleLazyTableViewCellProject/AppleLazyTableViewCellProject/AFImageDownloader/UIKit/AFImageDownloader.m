//
//  AFImageDownloader.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/24/18.
//  Copyright © 2018 Admin . All rights reserved.
//
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/
//  http://ios.jobbole.com/91703/


#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "AFImageDownloader.h"
#import "AFHTTPSessionManager.h"

@interface AFImageDownloaderResponseHandler : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, copy) void (^successBlock)(NSURLRequest*, NSHTTPURLResponse*, UIImage*);
@property (nonatomic, copy) void (^failureBlock)(NSURLRequest*, NSHTTPURLResponse*, NSError*);
@end

@implementation AFImageDownloaderResponseHandler

- (instancetype)initWithUUID:(NSUUID *)uuid
                     success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *responseObject))success
                     failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure {
    if (self = [self init]) {
        self.uuid = uuid;
        self.successBlock = success;
        self.failureBlock = failure;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"<AFImageDownloaderResponseHandler>UUID: %@", [self.uuid UUIDString]];
}

@end

@interface AFImageDownloaderMergedTask : NSObject
@property (nonatomic, strong) NSString *URLIdentifier;
@property (nonatomic, strong) NSUUID *identifier;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSMutableArray <AFImageDownloaderResponseHandler*> *responseHandlers;

@end

@implementation AFImageDownloaderMergedTask

- (instancetype)initWithURLIdentifier:(NSString *)URLIdentifier identifier:(NSUUID *)identifier task:(NSURLSessionDataTask *)task {
    if (self = [self init]) {
        self.URLIdentifier = URLIdentifier;
        self.task = task;
        self.identifier = identifier;
        self.responseHandlers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addResponseHandler:(AFImageDownloaderResponseHandler*)handler {
    [self.responseHandlers addObject:handler];
}

- (void)removeResponseHandler:(AFImageDownloaderResponseHandler*)handler {
    [self.responseHandlers removeObject:handler];
}

@end

@implementation AFImageDownloadReceipt

- (instancetype)initWithReceiptID:(NSUUID *)receiptID task:(NSURLSessionDataTask *)task {
    if (self = [self init]) {
        self.receiptID = receiptID;
        self.task = task;
    }
    return self;
}

@end

@interface AFImageDownloader ()

@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@property (nonatomic, strong) dispatch_queue_t responseQueue;

@property (nonatomic, assign) NSInteger maximumActiveDownloads;
@property (nonatomic, assign) NSInteger activeRequestCount;

@property (nonatomic, strong) NSMutableArray *queuedMergedTasks;
@property (nonatomic, strong) NSMutableDictionary *mergedTasks;

@end

@implementation AFImageDownloader

+ (NSURLCache *)defaultURLCache {
    return [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                         diskCapacity:150 * 1024 * 1024
                                             diskPath:@"com.alamofire.imagedownloader"];
}

+ (NSURLSessionConfiguration *)defaultURLSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //TODO set the default HTTP headers
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = 60.0;
    configuration.URLCache = [AFImageDownloader defaultURLCache];
    
    return configuration;
}

- (instancetype)init {
    NSURLSessionConfiguration *defaultConfiguration = [self.class defaultURLSessionConfiguration];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:defaultConfiguration];
    sessionManager.responseSerializer = [AFImageResponseSerializer serializer];
    
    return [self initWithSessionManager:sessionManager
                 downloadPrioritization:AFImageDownloadPrioritizationFIFO
                 maximumActiveDownloads:4
                             imageCache:[[AFAutoPurgingImageCache alloc] init]];
}

- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)sessionManager
                downloadPrioritization:(AFImageDownloadPrioritization)downloadPrioritization
                maximumActiveDownloads:(NSInteger)maximumActiveDownloads
                            imageCache:(id <AFImageRequestCache>)imageCache {
    if (self = [super init]) {
        self.sessionManager = sessionManager;
        
        self.downloadPrioritizaton = downloadPrioritization;
        self.maximumActiveDownloads = maximumActiveDownloads;
        self.imageCache = imageCache;
        
        self.queuedMergedTasks = [[NSMutableArray alloc] init];
        self.mergedTasks = [[NSMutableDictionary alloc] init];
        self.activeRequestCount = 0;
        /*
        这里创建了两个queue：一个串行的请求queue，和一个并行的响应queue。
        这个串行queue,是用来做内部生成task等等一系列业务逻辑的。它保证了我们在这些逻辑处理中的线程安全问题（迷惑的接着往下看）
        这个并行queue，被用来做网络请求完成的数据回调。
        */
        
        NSString *name = [NSString stringWithFormat:@"com.alamofire.imagedownloader.synchronizationqueue-%@", [[NSUUID UUID] UUIDString]];
        self.synchronizationQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        name = [NSString stringWithFormat:@"com.alamofire.imagedownloader.responsequeue-%@", [[NSUUID UUID] UUIDString]];
        self.responseQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

+ (instancetype)defaultInstance {
    static AFImageDownloader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nullable AFImageDownloadReceipt *)downloadImageForURLRequest:(NSURLRequest *)request
                                                        success:(void (^)(NSURLRequest * _Nonnull, NSHTTPURLResponse * _Nullable, UIImage * _Nonnull))success
                                                        failure:(void (^)(NSURLRequest * _Nonnull, NSHTTPURLResponse * _Nullable, NSError * _Nonnull))failure {
    return [self downloadImageForURLRequest:request withReceiptID:[NSUUID UUID] success:success failure:failure];
}

- (nullable AFImageDownloadReceipt *)downloadImageForURLRequest:(NSURLRequest *)request
                                                  withReceiptID:(nonnull NSUUID *)receiptID
                                                        success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject))success
                                                        failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure {
    //还是类似之前的，同步串行去做下载的事 生成一个task,这些事情都是在当前线程中串行同步做的，所以不用担心线程安全问题。
    __block NSURLSessionDataTask *task = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        NSString *URLIdentifier = request.URL.absoluteString;
        if (URLIdentifier == nil) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(request, nil, error);
                });
            }
            return;
        }
        
        // 1) Append the success and failure blocks to a pre-existing request if it already exists
        //如果这个任务已经存在，则添加成功失败Block,然后直接返回，即一个url用一个request,可以响应好几个block
        //从自己task字典中根据Url去取AFImageDownloaderMergedTask，里面有task id url等等信息
        AFImageDownloaderMergedTask *existingMergedTask = self.mergedTasks[URLIdentifier];
        if (existingMergedTask != nil) {
            //里面包含成功和失败Block和UUid
            AFImageDownloaderResponseHandler *handler = [[AFImageDownloaderResponseHandler alloc] initWithUUID:receiptID success:success failure:failure];
            [existingMergedTask addResponseHandler:handler];
            task = existingMergedTask.task;
            return;
        }
        
        // 2) Attempt to load the image from the image cache if the cache policy allows it
        // 根据request的缓存策略，加载缓存
        DLog(@"request:%@", request.URL.absoluteString);
        switch (request.cachePolicy) {
            case NSURLRequestUseProtocolCachePolicy:
            case NSURLRequestReturnCacheDataElseLoad:
            case NSURLRequestReturnCacheDataDontLoad: {
                //从cache中根据request拿数据.
                // If request.URL.absoluteString was downloaded before, just get image from cache.
                UIImage *cachedImage = [self.imageCache imageforRequest:request withAdditionalIdentifier:nil];
                if (cachedImage != nil) {
                    if (success) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(request, nil, cachedImage);
                        });
                    }
                    return;
                }
                break;
            }
            default:
                break;
        }
        
        // 3) Create the request and set up authentication, validation and response serialization
        // 走到这说明即没有请求中的request,也没有cache,开始请求
        NSUUID *mergedTaskIdentifier = [NSUUID UUID];
        NSURLSessionDataTask *createdTask;
        __weak __typeof__(self) weakSelf = self;
        
        //用sessionManager的去请求，注意，只是创建task,还是挂起状态
        createdTask = [self.sessionManager
                       dataTaskWithRequest:request
                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                           
                           //在responseQueue中回调数据,初始化为并行queue
                           dispatch_async(self.responseQueue, ^{
                               __strong __typeof__(weakSelf) strongSelf = weakSelf;
                               // 拿到当前的task
                               AFImageDownloaderMergedTask *mergedTask = self.mergedTasks[URLIdentifier];
                               // 如果之前的task数组中，有这个请求的任务task，则从数组中移除
                               if ([mergedTask.identifier isEqual:mergedTaskIdentifier]) {
                                   // 安全的移除，并返回当前被移除的AF task
                                   mergedTask = [strongSelf safelyRemoveMergedTaskWithURLIdentifier:URLIdentifier];
                                   // 请求错误
                                   if (error) {
                                       //去遍历task所有响应的处理
                                       for (AFImageDownloaderResponseHandler *handler in mergedTask.responseHandlers) {
                                           //主线程，调用失败的Block
                                           if (handler.failureBlock) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   handler.failureBlock(request, (NSHTTPURLResponse*)response, error);
                                               });
                                           }
                                       }
                                   } else {
                                       //成功根据request,往cache里添加
                                       [strongSelf.imageCache addImage:responseObject forRequest:request withAdditionalIdentifier:nil];
                                       //调用成功Block
                                       for (AFImageDownloaderResponseHandler *handler in mergedTask.responseHandlers) {
                                           if (handler.successBlock) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   handler.successBlock(request, (NSHTTPURLResponse*)response, responseObject);
                                               });
                                           }
                                       }
                                       
                                   }
                               }
                               //减少活跃的任务数
                               [strongSelf safelyDecrementActiveTaskCount];
                               [strongSelf safelyStartNextTaskIfNecessary];
                           });
                       }];
        
        // 4) Store the response handler for use when the request completes
        // 创建handler
        AFImageDownloaderResponseHandler *handler = [[AFImageDownloaderResponseHandler alloc] initWithUUID:receiptID
                                                                                                   success:success
                                                                                                   failure:failure];
        //创建task
        AFImageDownloaderMergedTask *mergedTask = [[AFImageDownloaderMergedTask alloc]
                                                   initWithURLIdentifier:URLIdentifier
                                                   identifier:mergedTaskIdentifier
                                                   task:createdTask];
        //添加handler
        [mergedTask addResponseHandler:handler];
        self.mergedTasks[URLIdentifier] = mergedTask;
        
        // 5) Either start the request or enqueue it depending on the current active request count
        //如果小于，则开始任务下载resume
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            [self startMergedTask:mergedTask];
        } else {
            [self enqueueMergedTask:mergedTask];
        }
        //拿到最终生成的task
        task = mergedTask.task;
    });
    if (task) {
        //创建一个AFImageDownloadReceipt并返回，里面就多一个receiptID。
        return [[AFImageDownloadReceipt alloc] initWithReceiptID:receiptID task:task];
    } else {
        return nil;
    }
}

- (void)cancelTaskForImageDownloadReceipt:(AFImageDownloadReceipt *)imageDownloadReceipt {
    dispatch_sync(self.synchronizationQueue, ^{
        NSString *URLIdentifier = imageDownloadReceipt.task.originalRequest.URL.absoluteString;
        AFImageDownloaderMergedTask *mergedTask = self.mergedTasks[URLIdentifier];
        NSUInteger index = [mergedTask.responseHandlers indexOfObjectPassingTest:^BOOL(AFImageDownloaderResponseHandler * _Nonnull handler, __unused NSUInteger idx, __unused BOOL * _Nonnull stop) {
            return handler.uuid == imageDownloadReceipt.receiptID;
        }];
        
        if (index != NSNotFound) {
            AFImageDownloaderResponseHandler *handler = mergedTask.responseHandlers[index];
            [mergedTask removeResponseHandler:handler];
            NSString *failureReason = [NSString stringWithFormat:@"ImageDownloader cancelled URL request: %@",imageDownloadReceipt.task.originalRequest.URL.absoluteString];
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey:failureReason};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
            if (handler.failureBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler.failureBlock(imageDownloadReceipt.task.originalRequest, nil, error);
                });
            }
        }
        
        if (mergedTask.responseHandlers.count == 0 && mergedTask.task.state == NSURLSessionTaskStateSuspended) {
            [mergedTask.task cancel];
            [self removeMergedTaskWithURLIdentifier:URLIdentifier];
        }
    });
}

- (AFImageDownloaderMergedTask*)safelyRemoveMergedTaskWithURLIdentifier:(NSString *)URLIdentifier {
    __block AFImageDownloaderMergedTask *mergedTask = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        mergedTask = [self removeMergedTaskWithURLIdentifier:URLIdentifier];
    });
    return mergedTask;
}

//This method should only be called from safely within the synchronizationQueue
- (AFImageDownloaderMergedTask *)removeMergedTaskWithURLIdentifier:(NSString *)URLIdentifier {
    AFImageDownloaderMergedTask *mergedTask = self.mergedTasks[URLIdentifier];
    [self.mergedTasks removeObjectForKey:URLIdentifier];
    return mergedTask;
}

- (void)safelyDecrementActiveTaskCount {
    dispatch_sync(self.synchronizationQueue, ^{
        if (self.activeRequestCount > 0) {
            self.activeRequestCount -= 1;
        }
    });
}

- (void)safelyStartNextTaskIfNecessary {
    dispatch_sync(self.synchronizationQueue, ^{
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            while (self.queuedMergedTasks.count > 0) {
                AFImageDownloaderMergedTask *mergedTask = [self dequeueMergedTask];
                if (mergedTask.task.state == NSURLSessionTaskStateSuspended) {
                    [self startMergedTask:mergedTask];
                    break;
                }
            }
        }
    });
}

- (void)startMergedTask:(AFImageDownloaderMergedTask *)mergedTask {
    [mergedTask.task resume];
    ++self.activeRequestCount;
}

- (void)enqueueMergedTask:(AFImageDownloaderMergedTask *)mergedTask {
    switch (self.downloadPrioritizaton) {
        case AFImageDownloadPrioritizationFIFO:
            [self.queuedMergedTasks addObject:mergedTask];
            break;
        case AFImageDownloadPrioritizationLIFO:
            [self.queuedMergedTasks insertObject:mergedTask atIndex:0];
            break;
    }
}

- (AFImageDownloaderMergedTask *)dequeueMergedTask {
    AFImageDownloaderMergedTask *mergedTask = nil;
    mergedTask = [self.queuedMergedTasks firstObject];
    [self.queuedMergedTasks removeObject:mergedTask];
    return mergedTask;
}

- (BOOL)isActiveRequestCountBelowMaximumLimit {
    return self.activeRequestCount < self.maximumActiveDownloads;
}

@end
#endif
