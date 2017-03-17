//
//  UIImageView+WebCache.h
//  CaknowGZ
//
//  Created by gongzhen on 3/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebCache)

- (void)processImageDataWithURLString:(NSString *)url completionBlock:(void(^)(NSData *imageData, BOOL successed)) processedImage;

@end
