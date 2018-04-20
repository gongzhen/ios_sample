//
//  ServiceOperation.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "ServiceOperation.h"
#import "BackendService.h"
#import "BackendConfiguration.h"

@interface ServiceOperation()

@end

@implementation ServiceOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _service = [[BackendService alloc] initWithConf:[BackendConfiguration sharedMamager]];
    }
    return self;
}

- (void)cancel {
    [_service cancel];
    [super cancel];
}

@end
