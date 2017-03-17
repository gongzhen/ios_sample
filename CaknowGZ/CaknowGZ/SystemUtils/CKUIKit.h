//
//  CKUIKit.h
//  CKCaknow
//
//  Created by gongzhen on 12/16/16.
//  Copyright © 2016 CAKNOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKUIKit : NSObject

+ (UIView *)generateView;

+ (UIView *)generateViewWithColor:(UIColor *)color;

+ (UIButton *)generateButton;

+ (UIButton *)generateCustomButtonWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor backgroundImage:(UIImage *)image;

+ (UIButton *)generateNormalButtonWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor backgroundImage:(UIImage *)image;

+ (UILabel *)generateLabel;

+ (UIImageView *)generateImageViewWithBackgroundColor:(UIColor *)bgColor;

+ (UIView *)viewWithBackgroundColor:(UIColor *)color;

+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat)size;

+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)size;

+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger)numberOfLines
                           text:(NSString *)text
                       fontSize:(CGFloat)size;

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                        textAlighment:(NSTextAlignment)textAlighment
                        numberOfLines:(NSInteger)numberOfLines
                                 text:(NSString *)text
                             fontSize:(CGFloat)size;

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleState:(UIControlState)state
                   titleColor:(UIColor *)titleColor
              backgroundImage:(UIImage *)image
                   imageState:(UIControlState)imageState
                     fontSize:(CGFloat)size;

+ (UITextView *)generateTextViewWithColor:(UIColor *)color font:(UIFont *)font;

@end
