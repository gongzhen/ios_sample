//
//  SignInOperation.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "SignInOperation.h"
#import "BackendService.h"
#import "SignInRequest.h"
#import "SignInItem.h"

@interface SignInOperation() {
    SignInRequest* _request;
}
@end

@implementation SignInOperation

- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password 
{
    self = [super init];
    if (self) {
        DLog(@"email:%@ password:%@", email, password);
        _request = [[SignInRequest alloc] initWithEmail:email password:password];
    }
    return self;
}

- (void)start {
    [super start];
    
    void(^handleSuccess)(id response) = ^(id response){
        NSDictionary *json = (NSDictionary *)response;
        NSString *token = [json objectForKey:@"token"];
        NSString *uniqueId = [[json objectForKey:@"user"] objectForKey:@"id"];
        SignInItem *item = [[SignInItem alloc] initWithToken:token password:uniqueId];
        self.successBlock(item);
        [self finish];
    };
    
    void(^handleFailure)(NSError * error) = ^(NSError * error){
        self.failureBlock(error);
        [self finish];
    };
    DLog(@"service:%@", self.service);
    [self.service request:_request success:handleSuccess failure:handleFailure];
}




@end
