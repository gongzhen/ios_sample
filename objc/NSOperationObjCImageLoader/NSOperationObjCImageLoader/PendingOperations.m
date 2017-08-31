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
        _map = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)updateMapWithKey:(NSString *)key {
    NSNumber* count = [_map valueForKey:key];
    if(count == nil) {
        [_map setValue:@1 forKey:key];
    } else {
        int countInt = [count intValue];
        [_map setValue:@(countInt + 1) forKey:key];
    }
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
