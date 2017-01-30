//
//  FBSDKGraphRequest.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSDKGraphRequestConnection.h"


@interface FBSDKGraphRequest : NSObject

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

/**
 If set, disables the automatic error recovery mechanism.
 - Parameter disable: whether to disable the automatic error recovery mechanism
 
 By default, non-batched FBSDKGraphRequest instances will automatically try to recover
 from errors by constructing a `FBSDKGraphErrorRecoveryProcessor` instance that
 re-issues the request on successful recoveries. The re-issued request will call the same
 handler as the receiver but may occur with a different `FBSDKGraphRequestConnection` instance.
 
 This will override [FBSDKSettings setGraphErrorRecoveryDisabled:].
 */
- (void)setGraphErrorRecoveryDisabled:(BOOL)disable;

/**
 Starts a connection to the Graph API.
 - Parameter handler: The handler block to call when the request completes.
 */
- (FBSDKGraphRequestConnection *)startWithCompletionHandler:(FBSDKGraphRequestHandler)handler;

@end
