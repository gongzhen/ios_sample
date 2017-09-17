//
//  AsyncBlockOperation.m
//  AsyncBlockOperation
//
//  Created by zhen gong on 9/16/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "AsyncBlockOperation.h"

#pragma mark - AsyncBlockOperation

@implementation AsyncBlockOperation

- (nonnull instancetype)initWithBlock:(nonnull AsyncBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

+ (nonnull instancetype)blockOperationWithBlock:(nonnull AsyncBlock)block {
    AsyncBlockOperation *operation = [[AsyncBlockOperation alloc] initWithBlock:block];
    return operation;
}

- (void)start {
    [self willChangeValueForKey:@"isExecuting"];
    self.isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    if (self.block) {
        self.block(self);
    } else {
        [self complete];
    }
}

- (void)complete {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.isExecuting = NO;
    self.isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end

#pragma mark - NSOperationQueue+AsyncBlockOperation

@implementation NSOperationQueue (AsyncBlockOperation)

- (void)addOperationWithAsyncBlock:(nonnull AsyncBlock)block {
    AsyncBlockOperation *operation = [AsyncBlockOperation blockOperationWithBlock:block];
    [self addOperation:operation];
}

@end
