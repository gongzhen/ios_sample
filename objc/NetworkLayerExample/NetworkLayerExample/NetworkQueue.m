//
//  NetworkQueue.m
//  NetworkLayerExample
//
//  Created by Admin  on 4/15/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "NetworkQueue.h"

@interface NetworkQueue()

@end

@implementation NetworkQueue

+(instancetype)sharedMamager {
    static NetworkQueue *networkQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkQueue = [[self alloc] init];
    });
    return networkQueue;
}

- (NSOperationQueue *)queue {
    if(_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (void)addOperation:(NSOperation *)op {
    DLog(@"NetworkQueue:%@", op);
    DLog(@"self.queue:%@", self.queue);
    [self.queue addOperation:op];
}

@end
