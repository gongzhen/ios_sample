//
//  GZEasyTableSection.h
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GZNode.h"
#import "GZEasyTableRow.h"


@interface GZEasyTableSection : GZNode

@property (nonatomic, strong) id model;
@property (nonatomic, copy) NSString *identifier;

- (NSInteger)numberOfRows;

// GZEasyTableSection initializer
- (instancetype)initWithModel:(id)model;
- (instancetype)initWithModel:(id)model attributes:(NSDictionary *)attributes;

//
- (void)setCellHeight:(CGFloat)cellHeight atRow:(NSInteger)row;
- (CGFloat)cellHeightAtRow:(NSInteger)row;


- (void)addRow:(GZEasyTableRow *)row;
@end
