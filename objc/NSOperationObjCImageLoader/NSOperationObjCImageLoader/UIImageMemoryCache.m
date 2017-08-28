//
//  UIImageMemoryCache.m
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "UIImageMemoryCache.h"

@interface UIImageMemoryCache()

@property (strong, nonatomic) NSCache *cache;

@end

@implementation UIImageMemoryCache

- (instancetype)init {
    if(self = [super init]) {
        self = [super init];
        self.cache = [[NSCache alloc] init];
        self.cache.totalCostLimit = 25 * (1024 * 1024);
    }
    return  self;
}

//cache an image with URL as key.
- (void) cacheImage:(UIImage * _Nonnull) image forURL:(NSURL * _Nonnull) url {
    if(image == nil) {
        return;
    }
    
    NSUInteger cost = image.size.width * image.size.height * 4;
    // The cost value is used to compute a sum encompassing the costs of all the objects in the cache. When memory is limited or when the total cost of the cache eclipses the maximum allowed total cost, the cache could begin an eviction process to remove some of its elements.
    [self.cache setObject:image forKey:url cost:cost];
}

//remove an image with url as key.
- (void) removeImageForURL:(NSURL * _Nonnull) url {
    [self.cache removeObjectForKey:url];
}

//delete all cache data.
- (void) purge {
    [self.cache removeAllObjects];
}

@end
