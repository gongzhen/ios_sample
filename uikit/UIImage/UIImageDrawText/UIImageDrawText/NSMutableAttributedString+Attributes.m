//
//  NSMutableAttributedString+Attributes.m
//  UIImageDrawText
//
//  Created by gongzhen on 2/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "NSMutableAttributedString+Attributes.h"

@implementation NSMutableAttributedString (Attributes)

- (void)setAttributedStringWithFont:(UIFont *)font withColor:(UIColor *)color withShadow:(NSShadow *)shadow withRange:(NSRange)range {
    
    [self addAttribute:NSFontAttributeName value:font range:range];
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    [self addAttribute:NSShadowAttributeName value:shadow range:range];
}

@end
