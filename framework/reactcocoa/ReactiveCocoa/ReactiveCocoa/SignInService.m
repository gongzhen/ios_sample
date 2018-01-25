//
//  SignInService.m
//  ReactiveCocoa
//
//  Created by Admin  on 1/23/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "SignInService.h"

@implementation SignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(SignInResponse)completeBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}

+ (__kindof NSString *)return:(NSString *)value {
    NSString *reason = [NSString stringWithFormat:@"value:%@", value];
    NSLog(@"reason:%@", reason);
    return reason;
}

//  + (__kindof RACStream *)return:(id)value {
//      NSString *reason = [NSString stringWithFormat:@"%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
//      @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
//  }

@end
