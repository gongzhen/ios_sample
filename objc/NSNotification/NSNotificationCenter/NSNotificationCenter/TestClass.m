//
//  TestClass.m
//  NSNotificationCenter
//
//  Created by gongzhen on 1/31/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "TestClass.h"

@implementation TestClass

- (void)testNotification {
    // All instances of TestClass will be notified
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TestNotification" object:self];
    NSLog (@"TestClass");
}

@end
