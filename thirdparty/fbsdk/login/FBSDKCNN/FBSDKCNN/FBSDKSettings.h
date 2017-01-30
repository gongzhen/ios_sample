//
//  FBSDKSettings.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDKSettings : NSObject

/**
 Returns the default Graph API version. Defaults to `FBSDK_TARGET_PLATFORM_VERSION`
 */
+ (NSString *)graphAPIVersion;

+ (BOOL)isGraphErrorRecoveryDisabled;

@end
