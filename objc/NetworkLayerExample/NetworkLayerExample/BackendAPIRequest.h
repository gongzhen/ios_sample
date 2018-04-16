//
//  BackendAPIRequest.h
//  NetworkLayerExample
//
//  Created by Admin  on 4/13/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackendAPIRequest <NSObject>

@property(copy, readonly) NSString *endpoint;
@property(copy, readonly) NSString *method;
@property(copy, readonly) NSString *query;
@property(copy, readonly) NSDictionary *parameters;
@property(copy, readonly) NSDictionary<NSString*, NSString*> *headers;

- (NSDictionary *)defaultJSONHeaders;

@end
