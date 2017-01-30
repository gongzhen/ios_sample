//
//  FBSDKGraphRequest.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKGraphRequest+Internal.h"
#import "FBSDKAccessToken.h"
#import "FBSDKGraphRequest.h"
#import "FBSDKSettings.h"
// constants
static NSString *const kGetHTTPMethod = @"GET";

@interface FBSDKGraphRequest()
@property (nonatomic, assign) FBSDKGraphRequestFlags flags;
@end

@implementation FBSDKGraphRequest

- (instancetype)init NS_UNAVAILABLE
{
    assert(0);
}



- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                            flags:(FBSDKGraphRequestFlags)flags {
    return [self initWithGraphPath:graphPath
                        parameters:parameters
                       tokenString:[FBSDKAccessToken currentAccessToken].tokenString
                        HTTPMethod:nil
                             flags:flags];
}

- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                      tokenString:(NSString *)tokenString
                       HTTPMethod:(NSString *)HTTPMethod
                            flags:(FBSDKGraphRequestFlags)flags {
    if ((self = [self initWithGraphPath:graphPath
                             parameters:parameters
                            tokenString:tokenString
                                version:[FBSDKSettings graphAPIVersion]
                             HTTPMethod:HTTPMethod])) {
        self.flags |= flags;
    }
    return self;
}

- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                      tokenString:(NSString *)tokenString
                          version:(NSString *)version
                       HTTPMethod:(NSString *)HTTPMethod {
    if ((self = [super init])) {
        _tokenString = [tokenString copy];
        _version = version ? [version copy] : [FBSDKSettings graphAPIVersion];
        _graphPath = [graphPath copy];
        _HTTPMethod = HTTPMethod ? [HTTPMethod copy] : kGetHTTPMethod;
        _parameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        if ([FBSDKSettings isGraphErrorRecoveryDisabled]) {
            _flags = FBSDKGraphRequestFlagDisableErrorRecovery;
        }
    }
    return self;
}

@end
