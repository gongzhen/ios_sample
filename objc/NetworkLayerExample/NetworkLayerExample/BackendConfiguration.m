//
//  BackendConfiguration.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "BackendConfiguration.h"

@interface BackendConfiguration()

@end

@implementation BackendConfiguration


+(instancetype)sharedMamager {
    static BackendConfiguration *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end
