//
//  ImageCacheConfig.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheConfig : NSObject

@property(assign, nonatomic) BOOL shouldDecompressImages;

@property (assign, nonatomic) BOOL shouldDisableiCloud;

@property (assign, nonatomic) BOOL shouldCacheImagesInMemory;

@property (assign, nonatomic) NSInteger maxCacheAge;

@property (assign, nonatomic) NSUInteger maxCacheSize;

@end
