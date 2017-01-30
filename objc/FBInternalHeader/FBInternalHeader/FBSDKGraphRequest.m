//
//  FBSDKGraphRequest.m
//  FBInternalHeader
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKGraphRequest+Internal.h"
@interface FBSDKGraphRequest()
@property (nonatomic, assign) FBSDKGraphRequestFlags flags;
@end

@implementation FBSDKGraphRequest

- (instancetype)init NS_UNAVAILABLE
{
    assert(0);
}

#pragma mark public method 
- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                       HTTPMethod:(NSString *)HTTPMethod {
    return [self initWithGraphPath:graphPath
                        parameters:parameters
                       tokenString:@"v2.8"
                           version:nil
                        HTTPMethod:HTTPMethod];
}

#pragma mark internal method
- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                            flags:(FBSDKGraphRequestFlags)flags {
    return [self initWithGraphPath:graphPath
                        parameters:parameters
                       tokenString:@"v2.8"
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
                                version:@"v2.8"
                             HTTPMethod:HTTPMethod])) {
        _flags |= flags;
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
        _version = [version copy];
        _graphPath = [graphPath copy];
        _HTTPMethod = HTTPMethod ? [HTTPMethod copy] : @"GET";
        _parameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];

    }
    return self;
}

@end
