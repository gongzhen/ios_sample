//
//  GZContactField.m
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "GZContactField.h"

@implementation GZContactField

- (instancetype)initWithType:(GZContactFieldType)type label:(NSString *)label value:(NSString *)value dataProviderIdentifier:(NSString *)dataProviderIdentifier
{
    if (self = [super init]) {
        _type = type;
        _label = label;
        _value = value;
        _dataProviderIdentifier = dataProviderIdentifier;
    }
    return self;
}

@end
