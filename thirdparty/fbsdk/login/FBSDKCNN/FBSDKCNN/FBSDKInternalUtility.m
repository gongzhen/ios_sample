//
//  FBSDKInternalUtility.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKInternalUtility.h"
#import "FBSDKApplicationDelegate.h"

@implementation FBSDKInternalUtility


+ (NSBundle *)bundleForStrings
{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *stringsBundlePath = [[NSBundle bundleForClass:[FBSDKApplicationDelegate class]]
                                       pathForResource:@"FacebookSDKStrings"
                                       ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:stringsBundlePath] ?: [NSBundle mainBundle];
    });
    return bundle;
}

@end
