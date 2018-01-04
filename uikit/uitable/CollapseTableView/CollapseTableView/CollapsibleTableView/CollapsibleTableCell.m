//
//  CollapsibleTableCell.m
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import "CollapsibleTableCell.h"
#import "TableRow.h"

@implementation CollapsibleTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.checkmark];
        [self.contentView addSubview:self.sersviceNameLabel];
        [self.contentView addSubview:self.servicePriceLabel];
    }
    return self;
}

- (void)updateFrame:(CGRect)frame row:(TableRow *)row indexPath:(NSIndexPath *)indexPath selected:(BOOL)selected {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
