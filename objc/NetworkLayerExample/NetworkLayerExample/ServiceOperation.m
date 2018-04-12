//
//  ServiceOperation.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "ServiceOperation.h"
#import "BackendService.h"

@interface ServiceOperation() {
    BackendService* _service;
}

@end

@implementation ServiceOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _service = [[BackendService alloc] init];
    }
    return self;
}

@end
