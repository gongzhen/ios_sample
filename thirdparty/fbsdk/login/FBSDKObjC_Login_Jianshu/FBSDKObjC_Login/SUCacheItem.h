//
//  SUCacheItem.h
//  FBSDKObjC_Login_Jianshu
//
//  Created by gongzhen on 12/9/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

// A container class to wrap profile and access token information.
@interface SUCacheItem : NSObject<NSSecureCoding>

@property (nonatomic, strong) FBSDKProfile *profile;
@property (nonatomic, strong) FBSDKAccessToken *token;

@end