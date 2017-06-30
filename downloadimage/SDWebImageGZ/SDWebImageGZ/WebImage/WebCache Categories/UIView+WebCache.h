//
//  UIView+WebCache.h
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageManager.h"
#import "WebImageDownloader.h" /// WebImageDownloaderProgressBlock

typedef void (^SetImageBlock)(UIImage * _Nullable image, NSData * _Nullable imageData);

@interface UIView (WebCache)

- (void)internalSetImageWithURL:(nullable NSURL *)url
               placeholderImage:(nullable UIImage *)image
                   operationKey:(nullable NSString *)operationKey
                  setImageBlock:(nullable SetImageBlock)setImageBlock
                       progress:(nullable WebImageDownloaderProgressBlock)progressBlock
                      completed:(nullable ExternalCompletionBlock)completedBlock;
    
    
@end
