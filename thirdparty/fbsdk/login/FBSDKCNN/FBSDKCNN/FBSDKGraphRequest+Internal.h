//
//  FBSDKGraphRequest+Internal.h
//  FBSDKCNN
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

// Generally, requests automatically issued by the SDK
// should not invalidate the token and should disableErrorRecovery
// so that we don't cause a sudden change in token state or trigger recovery
// out of context of any user action.
@property (nonatomic, assign) FBSDKGraphRequestFlags flags;
- (BOOL)isGraphErrorRecoveryDisabled;
- (BOOL)hasAttachments;
+ (BOOL)isAttachment:(id)item;
+ (NSString *)serializeURL:(NSString *)baseUrl
                    params:(NSDictionary *)params
                httpMethod:(NSString *)httpMethod;


@end
