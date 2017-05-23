//
//  GZAlphabeticalSortPostProcessor.m
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "GZAlphabeticalSortPostProcessor.h"

@implementation GZAlphabeticalSortPostProcessor

- (instancetype)initWithSortMode:(GZAlphabeticalSortPostProcessorSortMode)sortMode
{
    if (self = [super init]) {
        _sortMode = sortMode;
    }
    return self;
}

@end
