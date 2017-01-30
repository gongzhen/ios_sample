//
//  GZEasyTableRow.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "GZEasyTableRow.h"

NSString *const GZEasyTableRowCellHeightAttributeKey = @"NJEasyTableRowCellHeightAttributeKey";

@implementation GZEasyTableRow

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (instancetype)initWithModel:(id)model attributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.model = model;
        [self parseAttributes:attributes];
    }
    return self;
}

- (void)parseAttributes:(NSDictionary *)attributes {
    if (attributes) {
        NSNumber *cellHeight = attributes[GZEasyTableRowCellHeightAttributeKey];
        if ([cellHeight isKindOfClass:[NSNumber class]]) {
            self.cellHeight = cellHeight.floatValue;
        }
    }
}

@end
