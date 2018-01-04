//
//  TableRow.m
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import "TableRow.h"

@implementation TableRow

#pragma mark - initializer

- (instancetype)initWith:(NSString *)name price:(NSString *)price; {
    if(self = [super init]) {
        _name = name;
        _price = price;
        _selected = NO;
    }
    return self;
}


@end
