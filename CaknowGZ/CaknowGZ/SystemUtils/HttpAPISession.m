//
//  HttpAPISession.m
//  CaknowGZ
//
//  Created by gongzhen on 2/5/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "HttpAPISession.h"
#import "BaseEntity.h"

NSString *const kServerURL = @"https://dev.caknow.com/";

@implementation HttpAPISession

- (instancetype)initWithAPIKey:(NSString *)apiKey token:(NSString *)token {
    if(self = [super init]) {
        NSURLSessionConfiguration *_configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:_configuration];
        _apiKey = apiKey;
        _token = token;
    }
    return self;
}

- (NSURLSessionDataTask *)request:(NSString *)methodName
                             type:(HttpRequestType)type
                       parameters:(id)parameters
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kServerURL, methodName];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    if ([parameters count] > 0) {
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil]];
    }
    
    
    NSMutableString *httpMethodName = [NSMutableString new];
    
    switch (type) {
        case HttpRequestTypePost: {
            [httpMethodName setString:@"Post"];
            [request setHTTPMethod:@"POST"];
        }
            break;
        default:
            break;
    }
    
    [request setValue:_apiKey forHTTPHeaderField:@"x-api-key"];
    [request setValue:_token forHTTPHeaderField:@"x-access-token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            
        } else {
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableContainers error:nil];
            
            
            
            success(parsedData);
            
        }
    }];
    [task resume];
    return task;
}

- (id)convertJSONToEntity:(id)jsonObject methodName:(NSString *)methodName statusCode:(long)statusCode {
    id result;

    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary* jsonResult = [jsonObject objectForKey:@"payload"];
        if(!jsonObject) {
            return jsonObject;
        }
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            Class objectClass = NSClassFromString(methodName);
            id resultEntity = [[objectClass alloc] init];
            if ([resultEntity isKindOfClass:BaseEntity.class]) {
                
            }
            
        }
        
    
    }
    
    return result;
}

@end
