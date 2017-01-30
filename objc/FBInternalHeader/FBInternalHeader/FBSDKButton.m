//
//  FBSDKButton.m
//  FBInternalHeader
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKButton.h"
#import "FBSDKButton+Subclass.h"

@implementation FBSDKButton
{
    BOOL _skipIntrinsicContentSizing;
    BOOL _isExplicitlyDisabled;
}

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {

    }
    return self;
}

#pragma mark - Properties

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
}

#pragma mark - Subclass Methods

- (void)checkImplicitlyDisabled
{
    BOOL enabled = !_isExplicitlyDisabled;
    BOOL currentEnabled = [self isEnabled];
    [super setEnabled:enabled];
    if (currentEnabled != enabled) {
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
}
#pragma mark - Helper Methods

- (UIImage *)_backgroundImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius scale:(CGFloat)scale
{
    CGFloat size = 1.0 + 2 * cornerRadius;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, cornerRadius + 1.0, 0.0);
    CGPathAddArcToPoint(path, NULL, size, 0.0, size, cornerRadius, cornerRadius);
    CGPathAddLineToPoint(path, NULL, size, cornerRadius + 1.0);
    CGPathAddArcToPoint(path, NULL, size, size, cornerRadius + 1.0, size, cornerRadius);
    CGPathAddLineToPoint(path, NULL, cornerRadius, size);
    CGPathAddArcToPoint(path, NULL, 0.0, size, 0.0, cornerRadius + 1.0, cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0.0, cornerRadius);
    CGPathAddArcToPoint(path, NULL, 0.0, 0.0, cornerRadius, 0.0, cornerRadius);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
