//
//  TableSection.m
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import "TableSection.h"

@implementation TableSection

- (instancetype)initWithName:(NSString *)sectionName items:(NSMutableArray *)items collapsed:(BOOL)collapsed{
    if(self = [super init]) {
        _sectionName = sectionName;
        _sectionItems = [items copy];
        _collapsed = collapsed;
    }
    return self;
}

@end
