//
//  FBSDKSettings.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

// #import "FBSDKSettings+Internal.h"
#import "FBSDKCoreKit.h"
#import "FBSDKSettings.h"

static NSString *g_defaultGraphAPIVersion;
static BOOL g_disableErrorRecovery;

@implementation FBSDKSettings

+ (NSString *)graphAPIVersion
{
    return g_defaultGraphAPIVersion ?: FBSDK_TARGET_PLATFORM_VERSION;
}

+ (BOOL)isGraphErrorRecoveryDisabled {
    return g_disableErrorRecovery;
}

@end
