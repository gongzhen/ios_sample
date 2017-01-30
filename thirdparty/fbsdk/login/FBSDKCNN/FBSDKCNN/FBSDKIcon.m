//
//  FBSDKIcon.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/13/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKIcon.h"

@implementation FBSDKIcon

#pragma mark - Object Lifecycle

- (instancetype)initWithColor:(UIColor *)color
{
    if ((self = [super init])) {
        _color = [color copy];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithColor:[UIColor whiteColor]];
}

#pragma mark - Public API

- (UIImage *)imageWithSize:(CGSize)size
{
    if ((size.width == 0) || (size.height == 0)) {
        return nil;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef path = [self pathWithSize:size];
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGPathRef)pathWithSize:(CGSize)size
{
    return NULL;
}

@end
