//
//  UITableView+GZEasyTable.h
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZEasyTableModel.h"

// Create a catetory for UITableView
// But you have to create other model classes to help the category
@interface UITableView (GZEasyTable)

// Create strong, readlyonly model from TableModel class.
// Readonly will omit the setter method and prevent assignment via dot-notation.
// You cannot create a synthesized property in a Category in Objective-C, I don't 
// http://stackoverflow.com/questions/8733104/objective-c-property-instance-variable-in-category
@property(nonatomic, strong, readonly) GZEasyTableModel *tableModel;

- (void)registAutolayoutCell:(UITableViewCell *)cell forAutomaticCalculationHeightIdentifier:(NSString *)identifier;


- (CGFloat)intrinsicHeightAtIndexPath:(NSIndexPath *)indexPath
                       forIdentifier:(NSString *)identifier
                    // (void(^)(id cell, id model))configBlock
                    // configBlock returns void and accepts two parameters, id cell and id model
                     configCellBlock:(void(^)(id cell, id model))configBlock;

@end
