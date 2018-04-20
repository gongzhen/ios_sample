//
//  ServiceOperation.h
//  NetworkLayerExample
//
//  Created by ULS on 4/11/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkOperation.h"


@class BackendService;

@interface ServiceOperation : NetworkOperation

@property(strong, nonatomic) BackendService* service;

@end
