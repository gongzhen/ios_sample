//
//  UIImage+Drawtext.m
//  UIImageDrawText
//
//  Created by gongzhen on 2/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "UIImage+Drawtext.h"

@implementation UIImage (Drawtext)

- (UIImage *)drawText:(NSMutableAttributedString *)text inImage:(UIImage *)image atPoint:(CGPoint)point font:(UIFont *)font textColor:(UIColor *)textColor{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}

- (UIImage *)drawText:(NSMutableAttributedString *)text inImage:(UIImage *)image atPoint:(CGPoint)point font:(UIFont *)font textColor:(UIColor *)textColor shadow:(NSShadow *)shadow {
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)drawText:(NSString *)text attributes:(NSDictionary *)attributes {
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGRect rect = [text boundingRectWithSize:CGSizeZero
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    //    [[UIColor whiteColor] set];
    [text drawAtPoint:CGPointMake(self.size.width / 2 - rect.size.width / 2, self.size.height / 2 - rect.size.height / 2) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
