//
//  UILabel+GZUILabelExtension.m
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "UILabel+GZUILabelExtension.h"

@implementation UILabel (GZUILabelExtension)

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                             textColor:(UIColor *)textColor
                         textAlighment:(NSTextAlignment)textAlighment
                         numberOFLines:(NSInteger)numberOfLines
                                  text:(NSString *)text
                             fontSize:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = backgroundColor;
    label.textColor = textColor;
    label.textAlignment = textAlighment;
    label.numberOfLines = numberOfLines;
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    return label;
}


@end
