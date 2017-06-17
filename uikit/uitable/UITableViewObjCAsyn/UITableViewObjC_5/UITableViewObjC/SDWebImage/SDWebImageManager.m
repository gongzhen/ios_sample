//
//  SDWebImageManager.m
//  UITableViewObjC_5
//
//  Created by gongzhen on 1/5/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "SDWebImageManager.h"

@interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *cacheOperation;

@end

@interface SDWebImageManager()

@property (strong, nonatomic) NSMutableSet *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

@end

@implementation SDWebImageManager

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    SDImageCache *cache = [[SDImageCache alloc] init];
    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc] init];
    return [self initWithCache:cache downloader:downloader];
}

- (instancetype)initWithCache:(SDImageCache *)cache downloader:(SDWebImageDownloader *)downloader {
    if (self = [super init]) {
        _imageCache = cache;
        _imageDownloader = downloader;
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}
//
//- (id<SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
//                                        options:(SDWebImageOptions)options
//                                       progress:(SDWebImageDownloaderProgressBlock)progressBlock
//                                      completed:(SDWebImageCompletionWithFinishedBlock)completedBlock {
//    // NSString convert to NSURL
//    if ([url isKindOfClass:NSString.class]) {
//        url = [NSURL URLWithString:(NSString *)url];
//    }
//    
//    if (![url isKindOfClass:NSURL.class]) {
//        url = nil;
//    }
//    
//    __block SDWebImageCombinedOperation *operation = [SDWebImageCombinedOperation new];
//    __weak SDWebImageCombinedOperation *weakOperation = operation;
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//
//}

@end

@implementation SDWebImageCombinedOperation

- (void)setCancelBlock:(SDWebImageNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
        
        // TODO: this is a temporary fix to #809.
        // Until we can figure the exact cause of the crash, going with the ivar instead of the setter
        //        self.cancelBlock = nil;
        _cancelBlock = nil;
    }
}

@end
