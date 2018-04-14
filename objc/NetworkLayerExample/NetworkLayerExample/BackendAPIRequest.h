//
//  BackendAPIRequest.h
//  NetworkLayerExample
//
//  Created by Admin  on 4/13/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@protocol BackendAPIRequest <NSObject>

@property(copy, readonly) NSString *endpoint;
@property(assign, readonly) Method method;
@property(assign, readonly) QueryType query;
@property(copy, readonly) NSDictionary *parameters;
@property(copy, readonly) NSDictionary<NSString*, NSString*> *headers;

- (NSDictionary *)defaultJSONHeaders;

@end
