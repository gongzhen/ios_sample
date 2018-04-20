//
//  BackendService.h
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackendAPIRequest.h"

@class BackendConfiguration;

@interface BackendService : NSObject

- (void)cancel;
- (void)request:(id<BackendAPIRequest>)request success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (instancetype)initWithConf:(BackendConfiguration *)conf;

@end
