//
//  main.m
//  NSNotificationCenter
//
//  Created by gongzhen on 1/31/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestNotification.h"
#import "TestClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        TestNotification *testNotification = [[TestNotification alloc] init];
        NSLog(@"%@", testNotification);
        TestClass *test = [[TestClass alloc] init];
        [test testNotification];
    }
    return 0;
}
