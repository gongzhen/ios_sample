//
//  Work.m
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "Work.h"

@implementation Work

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image info:(NSString *)info isExpanded:(BOOL)isExpanded {
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _info = info;
        _isExpanded = isExpanded;
    }
    return self;
}

@end
