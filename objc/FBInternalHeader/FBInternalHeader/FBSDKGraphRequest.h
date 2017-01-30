//
//  FBSDKGraphRequest.h
//  FBInternalHeader
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDKGraphRequest : NSObject


/**
 Initializes a new instance that use use `[FBSDKAccessToken currentAccessToken]`.
 - Parameter graphPath: the graph path (e.g., @"me").
 - Parameter parameters: the optional parameters dictionary.
 - Parameter HTTPMethod: the optional HTTP method. nil defaults to @"GET".
 */
- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                       HTTPMethod:(NSString *)HTTPMethod;


/**
 Initializes a new instance.
 - Parameter graphPath: the graph path (e.g., @"me").
 - Parameter parameters: the optional parameters dictionary.
 - Parameter tokenString: the token string to use. Specifying nil will cause no token to be used.
 - Parameter version: the optional Graph API version (e.g., @"v2.0"). nil defaults to `[FBSDKSettings graphAPIVersion]`.
 - Parameter HTTPMethod: the optional HTTP method (e.g., @"POST"). nil defaults to @"GET".
 */
- (instancetype)initWithGraphPath:(NSString *)graphPath
                       parameters:(NSDictionary *)parameters
                      tokenString:(NSString *)tokenString
                          version:(NSString *)version
                       HTTPMethod:(NSString *)HTTPMethod
NS_DESIGNATED_INITIALIZER;


/**
 The request parameters.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *parameters;

/**
 The access token string used by the request.
 */
@property (nonatomic, copy, readonly) NSString *tokenString;

/**
 The Graph API endpoint to use for the request, for example "me".
 */
@property (nonatomic, copy, readonly) NSString *graphPath;

/**
 The HTTPMethod to use for the request, for example "GET" or "POST".
 */
@property (nonatomic, copy, readonly) NSString *HTTPMethod;

/**
 The Graph API version to use (e.g., "v2.0")
 */
@property (nonatomic, copy, readonly) NSString *version;

@end
