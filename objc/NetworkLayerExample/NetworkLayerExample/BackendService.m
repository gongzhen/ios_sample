//
//  BackendService.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "BackendService.h"
#import "BackendConfiguration.h"
#import "NetworkService.h"

@interface BackendService() {
    BackendConfiguration *_conf;
    NetworkService *_service;
    
}

@end

@implementation BackendService

- (instancetype)initWithConf:(BackendConfiguration *)conf
{
    self = [super init];
    if (self) {
        _conf = conf;
    }
    return self;
}

- (void)request:(BackendAp)

@end
