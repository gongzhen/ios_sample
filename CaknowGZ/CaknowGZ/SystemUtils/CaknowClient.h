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

#pragma mark AccessToken
- (BOOL)saveAccessToken:(NSString *)accessToken;
- (BOOL)removeAccessToken;

@end
