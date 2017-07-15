//
//  CustomCollectionViewCell.m
//  ColletionViewCellNestedTableView
//
//  Created by zhen gong on 7/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]
                      initWithFrame:CGRectMake(10, 10, 300, 24)
                      ];
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor redColor];
        [self addSubview:self.label];
    }
    return self;
}

@end
