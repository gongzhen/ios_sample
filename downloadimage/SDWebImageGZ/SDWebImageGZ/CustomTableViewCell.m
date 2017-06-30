//
//  CustomTableViewCell.m
//  SDWebImageGZ
//
//  Created by zhen gong on 6/28/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "CustomTableViewCell.h"


@interface CustomTableViewCell()


@end

@implementation CustomTableViewCell

- (UIImageView *)cellImageView {
    if (_cellImageView == nil) {
        _cellImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [_cellImageView setContentMode:UIViewContentModeScaleAspectFit];
        _cellImageView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _cellImageView;
}
    
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self setupLayoutConstraint];
    }    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
    
- (void)setupLayoutConstraint {
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.f]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.cellImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.f]];
}

@end
