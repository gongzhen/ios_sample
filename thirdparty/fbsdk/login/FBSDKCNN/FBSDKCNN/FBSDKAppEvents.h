//
//  FBSDKAppEvents.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSDKMacros.h"
#import "FBSDKAccessToken.h"

@interface FBSDKAppEvents : NSObject

FBSDK_EXTERN NSString *const FBSDKAppEventNameFBSDKLoginButtonImpression;

+ (void)logImplicitEvent:(NSString *)eventName
              valueToSum:(NSNumber *)valueToSum
              parameters:(NSDictionary *)parameters
             accessToken:(FBSDKAccessToken *)accessToken;

+ (FBSDKAppEvents *)singleton;

@end
