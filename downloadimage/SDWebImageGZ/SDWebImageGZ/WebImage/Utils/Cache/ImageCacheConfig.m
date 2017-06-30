//
//  ImageCacheConfig.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ImageCacheConfig.h"

static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; /// One week for maximum length of cache lifetime.

@implementation ImageCacheConfig

- (instancetype)init {
    if (self = [super init]) {
        _shouldDecompressImages = YES;
        _shouldDisableiCloud = YES;
        _shouldCacheImagesInMemory = YES;
        _maxCacheAge = kDefaultCacheMaxCacheAge;
        _maxCacheSize = 0;
    }
    return self;
}

@end
