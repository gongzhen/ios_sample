//
//  SignInRequest.m
//  NetworkLayerExample
//
//  Created by Admin  on 4/13/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "SignInRequest.h"

@interface SignInRequest()

@end

@implementation SignInRequest {
    NSString *_email;
    NSString *_password;
}

-(instancetype)initWithEmail:(NSString *)email password:(NSString *)password {
    if(self = [super init]) {
        _email = email;
        _password = password;
    }
    return self;
}

-(NSString *)endpoint {
    return @"/signin";
}

- (NSString *)method {
    return @"post";
}

- (NSString *)query {
    return @"json";
}

- (NSDictionary *)parameters {
    return @{ @"email":_email, @"password":_password };
}

- (NSDictionary *)headers {
    return [self defaultJSONHeaders];
}

- (NSDictionary *)defaultJSONHeaders {
    return @{ @"Content-Type": @"application/json" };
}

@end
