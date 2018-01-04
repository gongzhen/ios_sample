//
//  TableRow.h
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableRow : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *price;
@property (assign, nonatomic) BOOL selected;

- (instancetype)initWith:(NSString *)name price:(NSString *)price;

@end
