//
//  PendingOperations.m
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations

- (instancetype)init {
    if(self = [super init]) {
    
    }
    return self;
}

- (NSOperationQueue *)downloadQueue {
    if(_downloadQueue == nil) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    return _downloadQueue;
}

- (NSMutableDictionary *)downloadsInProgress {
    if(_downloadsInProgress == nil) {
        _downloadsInProgress = [NSMutableDictionary new];
    }
    return _downloadsInProgress;
}

@end
