//
//  ProServicesTableViewCell.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 5/23/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ProServicesTableViewCell.h"
#import "Webservice.h"
#import "ProModel.h"

@interface ProServicesTableViewCell()

@property(strong, nonatomic)Webservice *webService;

@end

@implementation ProServicesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.frame = CGRectMake( 0, 0, 0, 0);
        self.imageView.frame = CGRectMake(0, 0, 0, 0);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)configure:(ProModel *)model index:(NSInteger)index {
    self.textLabel.text = [NSString stringWithFormat:@"%@[%ld]", model.name, index];
}

@end
