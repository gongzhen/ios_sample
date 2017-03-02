//
//  UIImage+Drawtext.h
//  UIImageDrawText
//
//  Created by gongzhen on 2/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Drawtext)

- (UIImage *)drawText:(NSMutableAttributedString *)text inImage:(UIImage *)image atPoint:(CGPoint)point font:(UIFont *)font textColor:(UIColor *)textColor;

- (UIImage *)drawText:(NSMutableAttributedString *)text inImage:(UIImage *)image atPoint:(CGPoint)point font:(UIFont *)font textColor:(UIColor *)textColor shadow:(NSShadow *)shadow;

- (UIImage *)drawText:(NSString *)text attributes:(NSDictionary *)attributes;

@end
