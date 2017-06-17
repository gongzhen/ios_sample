//
//  ReporterView.m
//  BlockRetainCycleObjc
//
//  Created by zhen gong on 6/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//  https://swiftcafe.io/2017/02/02/weak-block/

#import "ReporterView.h"

@interface ReporterView()

@end

@implementation ReporterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification)
                                                     name:@"Notification"
                                                   object:nil];
    }
    return self;
}

-(void)handleNotification
{
    DLog(@"Notification Received");
}

-(void)foo
{
    DLog(@"Foo is called.")
}

-(void)block:(void (^)(void))completionBlock {
    // doBlock is strong type
    DLog(@"ReporterView call block method");
    self.doBlock = completionBlock;
    self.doBlock();
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"dealloc");
}

@end
