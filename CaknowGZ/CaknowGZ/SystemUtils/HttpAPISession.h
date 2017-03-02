//
//  HttpAPISession.h
//  CaknowGZ
//
//  Created by gongzhen on 2/5/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HttpRequestType) {
    HttpRequestTypePost,
    HttpRequestTypeGET,
    HttpRequestTypePUT,
    HttpRequestTypeDELETE,
    HttpRequestTypePATCH
};

@interface HttpAPISession : NSObject {
    NSURLSession *_session;
    NSString *_apiKey;
    NSString *_token;
}

- (instancetype)initWithAPIKey:(NSString *)apiKey token:(NSString *)token;


- (NSURLSessionDataTask *)request:(NSString *)methodName
                             type:(HttpRequestType)type
                       parameters:(id)parameters
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *error))failure;

@end
