//
//  HttpAPISession.m
//  CaknowGZ
//
//  Created by gongzhen on 2/5/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "HttpAPISession.h"
#import "BaseEntity.h"
#import "SystemUtils.h"

NSString *const kServerURL = @"https://staging.caknow.com/";

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

- (void)setToken:(NSString *)accessToken {
    _token = accessToken;
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
        case HttpRequestTypeGET: {
            [httpMethodName setString:@"Get"];
            [request setHTTPMethod:@"GET"];
        }
            break;
        default:
            break;
    }
    
    [request setValue:_apiKey forHTTPHeaderField:@"x-api-key"];
    [request setValue:_token forHTTPHeaderField:@"x-access-token"];DLog(@"%@", _token);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *fullMethodName = [self getFullMethodNameByHttpMethod:httpMethodName method:methodName];
        if (error) {
            
        } else {
            NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableContainers error:nil];
            id result = [self convertJSONToEntity:parsedData methodName:fullMethodName statusCode:statusCode];
            success(result);
        }
    }];
    [task resume];
    return task;
}

- (id)convertJSONToEntity:(id)jsonObject methodName:(NSString *)methodName statusCode:(long)statusCode {
    id result;
    if ([SystemUtils isDictionaryClass:jsonObject]) {
        
        NSDictionary* jsonResult = [jsonObject objectForKey:@"payload"];
        if(!jsonResult) {
            return jsonObject;
        }
        
        if ([SystemUtils isDictionaryClass:jsonResult]) {
        Class objectClass = NSClassFromString([self convertMethodName:methodName]); 
        id resultEntity = [[objectClass alloc] init];
        if ([SystemUtils isBaseClass:resultEntity]) {
            [resultEntity performSelector:@selector(setAttributes:) withObject:jsonResult];
        }
        if(resultEntity) {
            result = resultEntity;
        } else {
            result = jsonObject;
        }
            
        } else {
            // handle error
        }
    }
    return result;
}

- (NSString *)convertMethodName:(NSString *)methodName {
    NSArray *components = [methodName componentsSeparatedByString:@"_"];
    NSString *resultString = @"";
    for (int i = 0; i < components.count; i++) {
        NSString *component = [components objectAtIndex:i];
        resultString = [resultString stringByAppendingString:[SystemUtils capitalizeFirstLetter:component]];
    }
    
    components = [resultString componentsSeparatedByString:@"-"];
    resultString = @"";
    for (int i = 0; i < components.count; i++) {
        NSString *component = [components objectAtIndex:i];
        resultString = [resultString stringByAppendingString:[SystemUtils capitalizeFirstLetter:component]];
    }
    components = [resultString componentsSeparatedByString:@"/"];
    resultString = @"";
    for (int i = 0; i < components.count; i++) {
        NSString *component = [components objectAtIndex:i];
        resultString = [resultString stringByAppendingString:[SystemUtils capitalizeFirstLetter:component]];
    }
    resultString = [NSString stringWithFormat:@"%@Entity", resultString];
    return resultString;
}

- (NSString *)getFullMethodNameByHttpMethod:(NSString *)httpMethod method:(NSString *)method {
    return [NSString stringWithFormat:@"%@%@", httpMethod, [SystemUtils capitalizeFirstLetter:method]];
}

@end
