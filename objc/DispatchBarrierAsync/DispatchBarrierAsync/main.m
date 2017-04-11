//
//  main.m
//  DispatchBarrierAsync
//
//  Created by gongzhen on 3/30/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        __block NSString *str = @"Test";
        dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(defaultQueue, ^{
            NSLog(@"--%@--1-", str);
            [NSThread sleepForTimeInterval:1];
            if([str isEqualToString:@"Test"]) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"--%@--2-", str);
            } else {
                NSLog(@"--changed:%@--", str);
            }
        });
        
        dispatch_async(defaultQueue, ^{
            NSLog(@"--%@--3-", str);
        });

        dispatch_async(defaultQueue, ^{
            str = @"Modify";
            NSLog(@"--%@--4-", str);
        });
        
        [NSThread sleepForTimeInterval:8];
        NSLog(@"Hello, World!");
    }
    return 0;
}
