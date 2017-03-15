//
//  HttpRequestManager.h
//  CaknowGZ
//
//  Created by gongzhen on 2/4/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpAPISession.h"

@interface HttpRequestManager : NSObject {
    @private
    NSString *_apiKey;
    NSString *_token;
    HttpAPISession *_session;
}

@property (strong,nonatomic) NSString *accessToken;

+ (HttpRequestManager *)sharedInstance;

- (void)setAccessToken:(NSString *)accessToken;

- (NSURLSessionDataTask *)create:(NSString *)methodName
                      parameters:(id)parameters
                         success:(void (^)(id))success;

- (NSURLSessionDataTask *)create:(NSString *)methodName
                      parameters:(id)parameters
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)read:(NSString *)methodName
                    parameters:(id)parameters
                       success:(void(^)(id))success;

- (NSURLSessionDataTask *)read:(NSString *)methodName
                    parameters:(id)parameters
                       success:(void(^)(id))success
                       failure:(void(^)(NSError *error))failure;





@end
