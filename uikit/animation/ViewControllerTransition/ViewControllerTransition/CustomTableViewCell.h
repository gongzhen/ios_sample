//
//  CustomTableViewCell.h
//  ViewControllerTransition
//
//  Created by zhen gong on 7/14/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTableViewCellDelegate <NSObject>

- (void)didSelectService:(NSString *)option;

- (void)didRemoveService:(NSString *)option;

@end

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel* titleField;
@property (strong, nonatomic) NSArray* options;
@property (strong, nonatomic) id<CustomTableViewCellDelegate>delegate;

- (void)updateWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image options:(NSArray *)options andIndexPath:(NSIndexPath *)indexPath;
- (void)doShowOptions;
- (void)doRemoveOptions;

@end
