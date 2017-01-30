//
//  FBSDKGraphRequest+Internal.h
//  FBInternalHeader
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKGraphRequest.h"

typedef NS_OPTIONS(NSUInteger, FBSDKGraphRequestFlags)
{
    FBSDKGraphRequestFlagNone = 0,
    // indicates this request should not use a client token as its token parameter
    FBSDKGraphRequestFlagSkipClientToken = 1 << 1,
    // indicates this request should not close the session if its response is an oauth error
    FBSDKGraphRequestFlagDoNotInvalidateTokenOnError = 1 << 2,
    // indicates this request should not perform error recovery
    FBSDKGraphRequestFlagDisableErrorRecovery = 1 << 3,
};

@interface FBSDKGraphRequest (Internal)

- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                            flags:(FBSDKGraphRequestFlags)flags;

- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                      tokenString:(NSString *)tokenString
                       HTTPMethod:(NSString *)HTTPMethod
                            flags:(FBSDKGraphRequestFlags)flags;

@property (nonatomic, assign) FBSDKGraphRequestFlags flags;

@end
