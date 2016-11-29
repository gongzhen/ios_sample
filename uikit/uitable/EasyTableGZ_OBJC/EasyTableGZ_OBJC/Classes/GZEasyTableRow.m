//
//  GZEasyTableRow.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "GZEasyTableRow.h"

@implementation GZEasyTableRow

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

@end
