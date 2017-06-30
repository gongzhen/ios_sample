//
//  UIImageView+WebCache.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebImageManager.h"
#import "WebImageDownloader.h" /// WebImageDownloaderProgressBlock

@interface UIImageView (WebCache)

-(void)setImageWithURL:(NSURL *)url;
    
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeHolder
               progress:(WebImageDownloaderProgressBlock)progressBlock
              completed:(ExternalCompletionBlock)completedBlock;
@end
