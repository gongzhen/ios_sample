//
//  CustomTableViewCell.m
//  ViewControllerTransition
//
//  Created by zhen gong on 7/14/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image options:(NSArray *)options andIndexPath:(NSIndexPath *)indexPath {
    if (_titleField == nil) {
        _titleField = [[UILabel alloc] initWithFrame:frame];
        [self.contentView addSubview:_titleField];
    }
    _titleField.text = title;
}

- (void)doShowOptions {

}

- (void)doRemoveOptions {
    
}

@end
