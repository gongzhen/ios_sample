//
//  NetworkService.h
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Method) {
    get,
    post,
    put,
    delete
};

typedef NS_ENUM(NSInteger, QueryType){
    json,
    path
};

@interface NetworkService : NSObject

- (void)makeRequestFor:(NSURL *)url
                method:(NSString *)method
                  type:(NSString *)type
                params:(NSDictionary *)params
               headers:(NSDictionary *)headers
               success:(void(^)( NSData*))success
               failure:(void(^)(NSData*, NSError *, NSInteger))failure;

- (void)cancel;
@end
