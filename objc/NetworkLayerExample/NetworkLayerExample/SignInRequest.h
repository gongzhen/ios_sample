//
//  SignInRequest.h
//  NetworkLayerExample
//
//  Created by Admin  on 4/13/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackendAPIRequest.h"

@interface SignInRequest : NSObject <BackendAPIRequest>

- (NSString *)endpoint;

- (NSString *)method;

- (NSString *)query;

- (NSDictionary *)parameters;

- (NSDictionary *)headers;

- (NSDictionary *)defaultJSONHeaders;

-(instancetype)initWithEmail:(NSString *)email password:(NSString *)password;

@end
