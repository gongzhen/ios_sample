//
//  UIImageView+WebCache.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "UIImageView+WebCache.h"

#import "UIView+WebCache.h" /// Import internalSetImageWithURL

@implementation UIImageView (WebCache)

-(void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil progress:nil completed:nil];
}
    
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeHolder
               progress:(WebImageDownloaderProgressBlock)progressBlock
              completed:(ExternalCompletionBlock)completedBlock {
    [self internalSetImageWithURL:url
                 placeholderImage:nil
                     operationKey:nil
                    setImageBlock:nil
                         progress:progressBlock completed:completedBlock];    
}
    
@end
