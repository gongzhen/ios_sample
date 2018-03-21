//
//  CustomTableViewCell.m
//  Meow Fest
//
//  Created by ULS on 3/21/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell()

@property(strong, nonatomic) UILabel *timeStampLabel, *titleLabel, *subTitleLabel;

/// imageView from super class
/// @property(strong, nonatomic) UIImageView *imageView;

@end

@implementation CustomTableViewCell

- (UILabel *)timeStampLabel {
    if(_timeStampLabel == nil) {
        _timeStampLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeStampLabel.textAlignment =  NSTextAlignmentCenter;
    }
    return _timeStampLabel;
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment =  NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if(_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.textAlignment =  NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self.contentView addSubview:self.timeStampLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect cellRect = self.contentView.frame;
    CGFloat yOffset = 0;
    CGRect timeStampRect = CGRectMake(0, yOffset, cellRect.size.width, 20);
    yOffset += timeStampRect.size.height + 5;
    CGRect imageViewRect = CGRectMake(30, yOffset, cellRect.size.width - 60, cellRect.size.height - 100);
    yOffset += imageViewRect.size.height;
    CGRect titleRect = CGRectMake(0, yOffset, cellRect.size.width, 20);
    yOffset += titleRect.size.height + 10;
    
    CGRect subTitleRect = CGRectMake(0, yOffset, cellRect.size.width, 20);
    _timeStampLabel.frame = timeStampRect;
    self.imageView.frame = imageViewRect;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _titleLabel.frame = titleRect;
    _subTitleLabel.frame = subTitleRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(NSDictionary *)catDict {
    self.timeStampLabel.text = [catDict objectForKey:@"timestamp"];
    self.titleLabel.text = [catDict objectForKey:@"title"];
    self.subTitleLabel.text = [catDict objectForKey:@"description"];\
}

@end
