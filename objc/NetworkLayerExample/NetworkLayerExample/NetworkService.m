//
//  NetworkService.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "NetworkService.h"

@interface NetworkService() {
    NSURLSessionDataTask *_task;
}

@end

@implementation NetworkService

- (void)makeRequestFor:(NSURL *)url
                method:(NSString *)method
                  type:(NSString *)type
                params:(NSDictionary *)params
               headers:(NSDictionary *)headers
               success:(void(^)( NSData*))success
               failure:(void(^)(NSData*, NSError *, NSInteger))failure {
    NSMutableURLRequest *mutableRequest = [self makeQueryFor:url params:params type:type];
    mutableRequest.allHTTPHeaderFields = headers;
    mutableRequest.HTTPMethod = method;
    NSURLSession *session = [NSURLSession sharedSession];
    _task = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            failure(nil, error, 0);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse == nil) {
                failure(nil, error, [httpResponse statusCode]);
                return;
            }
            
            if([httpResponse statusCode] >= 200 && [httpResponse statusCode] < 300) {
                success(data);
            } else {
                failure(nil, error, [httpResponse statusCode]);
            }
        }
    }];
    
    [_task resume];
}

- (void)cancel {
    [_task cancel];
}

- (nonnull NSMutableURLRequest *)makeQueryFor:(NSURL *)url
                        params:(NSDictionary *)params
                          type:(NSString *)type {
    if([type isEqualToString:@"json"]) {
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
        if(params != nil) {
            NSError *error = nil;
            mutableRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
        }
        return mutableRequest;
    } else if ([type isEqualToString:@"path"]) {
        __block NSMutableString *query = [NSMutableString stringWithString:@""];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *strKey = (NSString *)key;
            NSString *strValue = (NSString *)obj;
            [query appendString:[NSString stringWithFormat:@"%@%@=%@", query, strKey, strValue]];
        }];
        NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
        components.query = query;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
        return request;
    }
    return nil;
}

@end

