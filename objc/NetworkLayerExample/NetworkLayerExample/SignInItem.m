//
//  SignInItem.m
//  NetworkLayerExample
//
//  Created by Admin  on 4/15/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "SignInItem.h"

@implementation SignInItem

- (instancetype)initWithToken:(NSString *)token password:(NSString *)uniqueId {
    self = [super init];
    if (self) {
        _token = token;
        _uniqueId = uniqueId;
    }
    return self;
}

@end
