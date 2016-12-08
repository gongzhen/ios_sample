//
//  Work.h
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Work : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                         info:(NSString *)info
                   isExpanded:(BOOL)isExpanded;

@end
