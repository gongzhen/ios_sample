//
//  UIImage+WebCache.m
//  UITableViewObjC_5
//
//  Created by gongzhen on 1/5/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "UIImage+WebCache.h"
#import "objc/runtime.h"


@implementation UIImage (WebCache)

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    
    // [self sd_cancelCurrentImageLoad];
    // objc_setAssociatedObject(<#id object#>, <#const void *key#>, <#id value#>, <#objc_AssociationPolicy policy#>)
    
    if (!(options & SDWebImageDelayPlaceholder)) {
        // #define dispatch_main_async_safe(block)
        if ([NSThread isMainThread]) {
        
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    }
    
    if (url) {
        // check if activityView is enabled or not.
        
        __weak __typeof(self)wself = self;
        // SDWebImageManager
        // id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager ]
        
    
    }
    
}

@end
