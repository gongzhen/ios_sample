//
//  NetworkLayerConfiguration.m
//  NetworkLayerExample
//
//  Created by Admin  on 4/15/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "NetworkLayerConfiguration.h"
#import "BackendConfiguration.h"
#import "NetworkQueue.h"

@implementation NetworkLayerConfiguration

+(void)setUp {
    NSURL *url = [NSURL URLWithString:@"https://dev.mobilestyles.com"];
    [BackendConfiguration sharedMamager].baseURL = url;
    DLog(@"[BackendConfiguration sharedMamager].baseURL:%@", [BackendConfiguration sharedMamager].baseURL);
}

@end
