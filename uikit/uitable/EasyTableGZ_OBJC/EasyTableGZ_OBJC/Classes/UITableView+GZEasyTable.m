//
//  UITableView+GZEasyTable.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "UITableView+GZEasyTable.h"
#import <objc/runtime.h>

const char GZEasyTableModelKey;
const char GZEasyTableCellKey;

@implementation UITableView (GZEasyTable)

// Create strong, readlyonly model from TableModel class.
// Readonly will omit the setter method and prevent assignment via dot-notation.
// You cannot create a synthesized property in a Category in Objective-C, I don't
// http://stackoverflow.com/questions/8733104/objective-c-property-instance-variable-in-category
- (GZEasyTableModel *)tableModel {
    GZEasyTableModel *model = objc_getAssociatedObject(self, &GZEasyTableModelKey);
    // DLog(@"modelKey: %s|", &GZEasyTableModelKey);
    if (model == nil) {
        model = [[GZEasyTableModel alloc] init];
        objc_setAssociatedObject(self, &GZEasyTableModelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return model;
}

- (void)registAutolayoutCell:(UITableViewCell *)cell forAutomaticCalculationHeightIdentifier:(NSString *)identifier {
    DLog(@"cell %@", cell);
    if (cell == nil || identifier == nil) {
        return;
    }
    
    NSMutableDictionary *cellsDict = objc_getAssociatedObject(self, &GZEasyTableCellKey);
    DLog(@"GZEasyTableCellKey %s", &GZEasyTableCellKey);
    if (!cellsDict) {
        cellsDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &GZEasyTableCellKey, cellsDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [cellsDict setObject:cell forKey:identifier];
}

- (CGFloat)intrinsicHeightAtIndexPath:(NSIndexPath *)indexPath
                        forIdentifier:(NSString *)identifier
                      configCellBlock:(void (^)(id cell, id model))configBlock {
    id model = [self.tableModel modelAtIndexPath: indexPath];
    
    CGFloat cellHeight = [self.tableModel cellHeightAtIndexPath:indexPath];
    DLog(@"cellHeight: %fd", cellHeight);
    if (cellHeight > 0) {
        return cellHeight;
    }
    
    NSMutableDictionary *cellsDict = objc_getAssociatedObject(self, &GZEasyTableCellKey);
    DLog(@"GZEasyTableCellKey:%s|", &GZEasyTableCellKey);

    UITableViewCell *cell = [cellsDict objectForKey:identifier];
    NSAssert(cell != nil, @"registAutolayoutCell:forAutomaticCalculationHeightIdentifier: must be called");
    
    if (configBlock) {
        DLog(@"configBlock %@", configBlock);
        configBlock(cell, model);
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    DLog(@"cell.bounds:%@", NSStringFromCGRect(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 1.0f;
    DLog(@"height: %fd", height);
    [self.tableModel setCellHeight:height atIndexPath:indexPath];
    
    return height;
}



@end
