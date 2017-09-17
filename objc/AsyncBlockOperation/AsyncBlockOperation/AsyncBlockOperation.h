//
//  AsyncBlockOperation.h
//  AsyncBlockOperation
//
//  Created by zhen gong on 9/16/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double AsyncBlockOperationVersionNumber;
FOUNDATION_EXPORT const unsigned char AsyncBlockOperationVersionString[];

@class AsyncBlockOperation;
typedef void (^AsyncBlock)(AsyncBlockOperation * __nonnull);

@interface AsyncBlockOperation : NSOperation

@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, strong, nullable) AsyncBlock block;

- (nonnull instancetype)initWithBlock:(nonnull AsyncBlock)block;
+ (nonnull instancetype)blockOperationWithBlock:(nonnull AsyncBlock)block;
- (void)complete;

@end

#pragma mark - category

@interface NSOperationQueue (AsyncBlockOperation)

- (void)addOperationWithAsyncBlock:(nonnull AsyncBlock)block;

@end
