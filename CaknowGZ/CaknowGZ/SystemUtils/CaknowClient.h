//
//  CaknowClient.h
//  CaknowGZ
//
//  Created by gongzhen on 3/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaknowClient : NSObject

+ (CaknowClient *)sharedInstance;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(Boolean verified, NSError * error))completion;

#pragma mark -
@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;

#pragma mark AccessToken
- (NSString *)getAccessToken:(NSString *)service;
- (BOOL)saveAccessToken:(NSString *)accessToken service:(NSString *)service;
- (BOOL)removeAccessToken:(NSString *)service;

@end
