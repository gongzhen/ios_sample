//
//  NSMutableAttributedString+Attributes.h
//  UIImageDrawText
//
//  Created by gongzhen on 2/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Attributes)

- (void)setAttributedStringWithFont:(UIFont *)font withColor:(UIColor *)color withShadow:(NSShadow *)shadow withRange:(NSRange)range;

@end
