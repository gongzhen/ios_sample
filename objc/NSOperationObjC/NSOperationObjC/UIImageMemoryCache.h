//
//  UIImageMemoryCache.h
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageMemoryCache : NSObject

@property (nonatomic, readonly) NSCache * _Nullable cache;

//max cache size in bytes.
@property (nonatomic) NSUInteger maxBytes;

//cache an image with URL as key.
- (void) cacheImage:(UIImage * _Nonnull) image forURL:(NSURL * _Nonnull) url;

//remove an image with url as key.
- (void) removeImageForURL:(NSURL * _Nonnull) url;

//delete all cache data.
- (void) purge;

@end
