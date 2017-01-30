//
//  FBSDKAccessToken.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKAccessToken.h"

NSString *const FBSDKAccessTokenDidChangeNotification = @"com.facebook.sdk.FBSDKAccessTokenData.FBSDKAccessTokenDidChangeNotification";

static FBSDKAccessToken *g_currentAccessToken;

@implementation FBSDKAccessToken

+ (FBSDKAccessToken *)currentAccessToken
{
    return g_currentAccessToken;
}

@end
