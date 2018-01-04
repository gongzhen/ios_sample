//
//  CollapsibleTableViewHeader.h
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollapsibleTableViewHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) UIImageView *arrowImage;
// @property (weak, nonatomic) id<CollapsibleTableViewHeaderDelegate> delegate;

- (void)updateHeader:(NSString *)headerTitle;
- (void)setCollapsed:(BOOL)collapsed;

@end
