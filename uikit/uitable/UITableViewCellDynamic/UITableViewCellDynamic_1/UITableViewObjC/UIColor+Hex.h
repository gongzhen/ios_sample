//
//  UIColor+Hex.h
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor*) colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end
