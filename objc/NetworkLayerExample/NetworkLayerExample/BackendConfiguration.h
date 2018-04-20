//
//  BackendConfiguration.h
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackendConfiguration : NSObject

@property(strong, nonatomic)NSURL *baseURL;

+ (instancetype)sharedMamager;

@end
