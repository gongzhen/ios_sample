//
//  BackendService.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "BackendService.h"
#import "BackendAPIRequest.h"
#import "BackendConfiguration.h"
#import "NetworkService.h"

@interface BackendService() {
    BackendConfiguration *_conf;
}

@property(strong, nonatomic)NetworkService *service;

@end

@implementation BackendService

- (NetworkService *)service {
    if(_service == nil) {
        _service = [[NetworkService alloc] init];
    }
    return _service;
}

- (instancetype)initWithConf:(BackendConfiguration *)conf
{
    self = [super init];
    if (self) {
        _conf = conf;
    }
    return self;
}

- (void)request:(id<BackendAPIRequest>)request success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSURL *url = [_conf.baseURL URLByAppendingPathComponent:request.endpoint];
    NSDictionary *headers = request.headers;
    [self.service makeRequestFor:url method:request.method type:request.query params:request.parameters headers:headers success:^(NSData * data) {
        NSError *error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error) {
            
        } else {
            NSDictionary *dict = object;
            DLog(@"dict:%@", dict);
            success(dict);
        }
        
    } failure:^(NSData *data, NSError *error, NSInteger statusCode) {
        DLog(@"error:%@", error);
    }];
    
    
    
}

- (void)cancel {
    [_service cancel];
}

@end
