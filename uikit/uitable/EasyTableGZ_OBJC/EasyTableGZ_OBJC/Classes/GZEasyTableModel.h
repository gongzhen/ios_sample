//
//  GZEasyTableModel.h
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GZNode.h"
#import "GZEasyTableSection.h"
#import "GZEasyTableRow.h"

@interface GZEasyTableModel : GZNode

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (void)setSectionsWithModels:(NSArray *)sectionModels;
// block is a function defition without a function name.
// NSDctionary* (^)(id) is a block that return a NSDictionary with parameter as id
// block returns a NSDictionary type dictioanry and accept a single id model parameter.
// In implementation file, setterBlock(id model) returns a NSDictioanry dict.
- (void)setSectionsWithModels:(NSArray *)sectionModels
              attributeSetter:(NSDictionary *(^)(id model))setterBlock;

- (void)setCellHeight:(CGFloat)cellHeight atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath;
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;


- (void)addRowsWithModels:(NSArray *)rowModels attributeSetter:(NSDictionary *(^)(id model))setterBlock insection:(NSInteger)section;
- (void)addRowsWithModels:(NSArray *)rowModels inSection:(NSInteger)section;

@end
