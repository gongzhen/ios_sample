//
//  UIColor+Hex.m
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}


+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    NSString *cString = [color stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // check if cString has prefix "0X"
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // Seprate into red, green, blue substrings.
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    // red
    NSString *redString = [cString substringWithRange:range];
    
    // green
    range.location = 2;
    NSString *greenString = [cString substringWithRange:range];
    
    // blue
    range.location = 4;
    NSString *blueString = [cString substringWithRange:range];
    
    // scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redString] scanHexInt:&r];
    [[NSScanner scannerWithString:greenString] scanHexInt:&g];
    [[NSScanner scannerWithString:blueString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r/ 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
