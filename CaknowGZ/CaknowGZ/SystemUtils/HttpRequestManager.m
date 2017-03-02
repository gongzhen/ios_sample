//
//  HttpRequestManager.m
//  CaknowGZ
//
//  Created by gongzhen on 2/4/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "HttpRequestManager.h"

NSString *const CAKNOWAPIKEY = @"KZ0aDZYBWXWS/IHxtzfEFM8jPC8GB+S+vZc22HsSnHA=";


@implementation HttpRequestManager

+ (HttpRequestManager *)sharedInstance {
    static HttpRequestManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        
    });
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _apiKey = CAKNOWAPIKEY;
        _token = @"";
        _session = [[HttpAPISession alloc] initWithAPIKey:_apiKey token:_token];
    }
    return self;
}

- (NSURLSessionDataTask *)create:(NSString *)methodName
                      parameters:(id)parameters
                         success:(void (^)(id))success {
    return [self create:methodName parameters:parameters success:success failure:^(NSError *error) {
        
    }];
}

- (NSURLSessionDataTask *)create:(NSString *)methodName
                      parameters:(id)parameters
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *error))failure {
    return [_session request:methodName
                    type:HttpRequestTypePost
              parameters:parameters
                 success:^(id result) {
                     success(result);
                 } failure:^(NSError *error) {
                     failure(error);
                 }];
}


@end
