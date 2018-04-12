//
//  BackendConfiguration.m
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "BackendConfiguration.h"

@interface BackendConfiguration() {
    NSURL *_baseURL;
}

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

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}
@end
