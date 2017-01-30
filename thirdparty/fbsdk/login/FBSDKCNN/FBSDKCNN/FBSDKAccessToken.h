//
//  FBSDKAccessToken.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDKAccessToken : NSObject

/**
 Returns the user ID.
 */
@property (readonly, copy, nonatomic) NSString *userID;

/**
 Returns the opaque token string.
 */
@property (readonly, copy, nonatomic) NSString *tokenString;

/**
 Returns the "global" access token that represents the currently logged in user.
 
 The `currentAccessToken` is a convenient representation of the token of the
 current user and is used by other SDK components (like `FBSDKLoginManager`).
 */
+ (FBSDKAccessToken *)currentAccessToken;

@end
