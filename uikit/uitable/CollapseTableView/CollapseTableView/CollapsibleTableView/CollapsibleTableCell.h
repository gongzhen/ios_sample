//
//  CollapsibleTableCell.h
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableRow;
@class CollapsibleTableCell;

@interface CollapsibleTableCell : UITableViewCell

@property (strong, nonatomic) UIButton* checkmark;
@property (strong, nonatomic) UILabel *servicePriceLabel, *sersviceNameLabel;
// @property (weak, nonatomic) id<CollapsibleTableCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
- (void)updateFrame:(CGRect)frame row:(TableRow *)row indexPath:(NSIndexPath *)indexPath selected:(BOOL)selected;

@end
