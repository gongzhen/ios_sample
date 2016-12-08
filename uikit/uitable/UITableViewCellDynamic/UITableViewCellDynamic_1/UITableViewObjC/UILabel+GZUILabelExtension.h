//
//  UILabel+GZUILabelExtension.h
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (GZUILabelExtension)

+ (UILabel *)labelWithBackgroundColor:(UIColor *)backgroundColor
                            textColor:(UIColor *)textColor
                        textAlighment:(NSTextAlignment)textAlighment
                        numberOFLines:(NSInteger)numberOfLines
                                 text:(NSString *)text
                             fontSize:(CGFloat)size;
@end
