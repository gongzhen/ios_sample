//
//  TestNotification.m
//  NSNotificationCenter
//
//  Created by gongzhen on 1/31/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "TestNotification.h"

@implementation TestNotification

-(instancetype)init {
    if (self = [super init]){
        
        // Add this instance of TestClass as an observer of the TestNotification.
        // We tell the notification center to inform us of "TestNotification"
        // notifications using the receiveTestNotification: selector. By
        // specifying object:nil, we tell the notification center that we are not
        // interested in who posted the notification. If you provided an actual
        // object rather than nil, the notification center will only notify you
        // when the notification was posted by that particular object.
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"TestNotification"
                                                   object:nil];
    }
    return self;
}

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveTestNotification:(NSNotification *)notification {
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    if ([[notification name] isEqualToString:@"TestNotification"]) {
        NSLog (@"Successfully received the test notification!");
    }
    
}

@end
