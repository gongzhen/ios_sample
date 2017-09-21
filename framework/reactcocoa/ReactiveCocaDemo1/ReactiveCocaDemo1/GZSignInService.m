//
//  GZSignInService.m
//  ReactiveCocaDemo1
//
//  Created by Admin  on 9/20/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "GZSignInService.h"

@implementation GZSignInService

- (void)signInWithUsername:(NSString *)username password:(NSString *)password complete:(RWSignInResponse)completeBlock {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        BOOL success = [username isEqualToString:@"user"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}

@end
