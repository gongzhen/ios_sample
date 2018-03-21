//
//  CustomSpinnerTableViewCell.m
//  Meow Fest
//
//  Created by Admin  on 3/21/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "CustomSpinnerTableViewCell.h"

@interface CustomSpinnerTableViewCell()

@property(strong, nonatomic)UIActivityIndicatorView *spinner;

@end

@implementation CustomSpinnerTableViewCell

- (UIActivityIndicatorView *)spinner {
    if(_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _spinner;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self.contentView addSubview:self.spinner];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _spinner.center = self.contentView.center;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startAnimating {
    [_spinner startAnimating];
}

- (void)stopAnimating {
    [_spinner stopAnimating];
}

@end
