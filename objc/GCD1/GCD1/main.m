//
//  main.m
//  GCD1
//
//  Created by gongzhen on 4/2/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Solution : NSObject

@end

@implementation Solution

- (void)testSyn {
    // http://www.cocoachina.com/ios/20150731/12819.html
    NSLog(@"before sync - %@", [NSThread currentThread]);
    // block here.
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"sync - %@", [NSThread currentThread]);
    });
    NSLog(@"after sync - %@", [NSThread currentThread]);
}
- (void)testAsyn {
    // http://www.cocoachina.com/ios/20150731/12819.html
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"before - %@", [NSThread currentThread]);
    // block here.
    dispatch_async(queue, ^{
        NSLog(@"before sync - %@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"sync - %@", [NSThread currentThread]);
        });
        NSLog(@"after sync - %@", [NSThread currentThread]);
    });
    NSLog(@"after  - %@", [NSThread currentThread]);
    for(int i = 0; i < 10; i++) {
        sleep(1);
    }
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        Solution *obj = [Solution new];
//        [obj testSyn];
        [obj testAsyn];

    }
    return 0;
}
