//
//  NetworkOperation.m
//  NetworkLayerExample
//
//  Created by Admin  on 4/15/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "NetworkOperation.h"

@interface NetworkOperation() {
    BOOL _isReady;
    BOOL _isExecuting;
    BOOL _isFinished;
    BOOL _isCancelled;
}

@property (readwrite, nonatomic) BOOL cancelled;
@property (readwrite, nonatomic) BOOL executing;
@property (readwrite, nonatomic) BOOL finished;
@property (readwrite, nonatomic) BOOL asynchronous;
@property (readwrite, nonatomic) BOOL ready;

@end

@implementation NetworkOperation


@synthesize cancelled, executing, finished, asynchronous, ready;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isReady = YES;
        _isExecuting = NO;
        _isFinished = NO;
        _isCancelled = NO;
        self.name = @"Network Operation";
    }
    return self;
}

- (void)start {
    if(self.isExecuting == NO) {
        self.ready = NO;
        self.executing = YES;
        self.finished = NO;
        self.cancelled = NO;
        DLog(@"start operation");
    }
}

- (void)main {
    
}

- (void)finish {
    self.executing = NO;
    self.finished = YES;
    DLog(@"finish operation");
}

- (void)cancel {
    self.executing = NO;
    self.cancelled = YES;
    DLog(@"cancel operation");
}

- (BOOL)isReady {
    return _isReady;
}

- (void)ready:(BOOL)ready{
    [self updateForKey:@"isReady" change:^{
        _isReady = ready;
    }];
}

- (void)executing:(BOOL)executing{
    [self updateForKey:@"isExecuting" change:^{
        _isExecuting = executing;
    }];
}

- (BOOL)isExecuting {
    return _isExecuting;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (void)cancelled:(BOOL)cancel{
    [self updateForKey:@"isCancelled" change:^{
        _isCancelled = cancel;
    }];
}

- (BOOL)isFinished {
    return _isFinished;
}

- (BOOL)isCancelled {
    return _isCancelled;
}
- (void)updateForKey:(NSString *)key change:(void (^)(void))change {
    [self willChangeValueForKey:key];
    change();
    [self didChangeValueForKey:key];
}

@end
