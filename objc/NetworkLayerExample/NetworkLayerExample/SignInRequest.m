//
//  SignInRequest.m
//  NetworkLayerExample
//
//  Created by Admin  on 4/13/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "SignInRequest.h"
#import "BackendAPIRequest.h"

@interface SignInRequest() <BackendAPIRequest>


@end

@implementation SignInRequest {
    NSString *_email;
    NSString *_password;
}

@synthesize endpoint;
@synthesize method;
@synthesize query;
@synthesize parameters;
@synthesize headers;

-(instancetype)initWithEmail:(NSString *)email password:(NSString *)password {
    if(self = [super init]) {
        _email = email;
        _password = password;
    }
    return self;
}

-(NSString *)endpoint {
    return @"/users/sign_in";
}

- (NSDictionary *)defaultJSONHeaders {
    return @{
             @"Content-Type": @"application/json"
             };
}



@end
