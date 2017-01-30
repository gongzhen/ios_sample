//
//  GZEasyTableRow.h
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "GZNode.h"
#import <UIKit/UIKit.h>

@interface GZEasyTableRow : GZNode

@property (nonatomic, strong) id model;
@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithModel:(id)model;
- (instancetype)initWithModel:(id)model attributes:(NSDictionary *)attributes;

@end
