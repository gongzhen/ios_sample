//
//  TableSection.h
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableSection : NSObject

@property (copy, nonatomic) NSString *sectionName;
@property (copy, nonatomic) NSArray *sectionItems;
@property (assign, nonatomic) BOOL collapsed;

@end
