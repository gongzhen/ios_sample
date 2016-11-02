//
//  UIImage+Thumbnail.m
//  PhotoScrollObjC
//
//  Created by gongzhen on 10/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage (Thumbnail)

-(UIImage *)thumbnailOfSize:(CGFloat)size {
    // Create a rect
    CGRect rect = CGRectMake(0, 0, size, size);
    // image begins to generate context with rect.size
    UIGraphicsBeginImageContext(rect.size);
    // context is filled with rect
    [self drawInRect:rect];
    // get image from current context.
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // end
    UIGraphicsEndImageContext();
    // return thumbnail image.
    return thumbnail;
}

@end
