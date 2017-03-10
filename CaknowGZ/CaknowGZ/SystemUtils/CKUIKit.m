//
//  CKUIKit.m
//  CKCaknow
//
//  Created by gongzhen on 12/16/16.
//  Copyright © 2016 CAKNOW. All rights reserved.
//

#import "CKUIKit.h"

@implementation CKUIKit

+ (UIView *)generateView {
    return [self generateViewWithColor:[UIColor clearColor]];
}

+ (UIView *)generateViewWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:color];
    return view;
}

+ (UIButton *)generateButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    return button;
}

+ (UIButton *)generateNormalButtonWithTitle:(NSString *)title
                                 titleColor:(UIColor *)titleColor
                            backgroundImage:(UIImage *)image{
    UIButton *button = [[UIButton alloc] init];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

+ (UILabel *)generateLabel {
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    return label;
}

+ (UIView *)viewWithBackgroundColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:color];
    return view;
}

+ (UIImageView *)generateImageViewWithBackgroundColor:(UIColor *)bgColor {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [imageView setBackgroundColor:bgColor];
    return imageView;
}

+ (UILabel *)labelTextColor:(UIColor *)textColor
                   fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    return label;
}

+ (UILabel *)labelWithTextColor:(UIColor *)textColor
                  numberOfLines:(NSInteger)numberOfLines
                           text:(NSString *)text
                       fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    
    return label;
}

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                        textAlighment:(NSTextAlignment)textAlighment
                        numberOfLines:(NSInteger)numberOfLines
                                 text:(NSString *)text
                             fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.backgroundColor = backgroundColor;
    label.textColor = textColor;
    label.textAlignment = textAlighment;
    label.numberOfLines = numberOfLines;
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:size];
    return label;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleState:(UIControlState)state
                   titleColor:(UIColor *)titleColor
              backgroundImage:(UIImage *)image
                   imageState:(UIControlState)imageState
                     fontSize:(CGFloat)size {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:state];
    [button setTitleColor:titleColor forState:state];
    [button setBackgroundImage:image forState:state];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:size];
    return button;
}

+ (UITextView *)generateTextViewWithColor:(UIColor *)color font:(UIFont *)font {
    UITextView *textView = [[UITextView alloc] init];
    [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [textView setTextColor:color];
    [textView setFont:font];
    return textView;
}

@end
