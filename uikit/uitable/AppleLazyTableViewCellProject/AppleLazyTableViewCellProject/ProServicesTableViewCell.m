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
        self.imageView.frame = CGRectMake(0, 0, 48, 48);
        self.textLabel.frame = CGRectMake( 55, 0, self.contentView.frame.size.width - 60, 48);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

- (void)configure:(ProModel *)model index:(NSInteger)index {
    self.textLabel.text = [NSString stringWithFormat:@"%@[%ld]", model.name, index];
}

@end
