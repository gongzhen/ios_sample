//
//  GZEasyTableSection.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "GZEasyTableSection.h"
#import "GZEasyTableRow.h"

@interface GZEasyTableSection() {
    NSInteger _numberOfRows;
    NSMutableDictionary *_rowHeightDict;
}

@end

@implementation GZEasyTableSection

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

-(instancetype)initWithModel:(id)model attributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.model = model;
        [self parseAttributes:attributes];
    }
    return self;
}

- (void)parseAttributes:(NSDictionary *)attributes {
    if (attributes) {
        NSNumber *numberOfRows = [attributes valueForKey:@"NJEasyTableSectionNumberOfRowsAttributeKey"];
        if ([numberOfRows isKindOfClass: [NSNumber class]]) {
            // get number of rows
            [self setNumberOfRows:numberOfRows.integerValue];
        }
    }
}

- (void)setNumberOfRows:(NSInteger)numberOfRows {
    _numberOfRows = numberOfRows;
}

- (NSInteger)numberOfRows {
    NSUInteger count = self.children.count;
    
    if (count > 0) {
        return count;
    } else if (_numberOfRows > 0) {
        return _numberOfRows;
    } else {
        return 1;
    }
}

- (CGFloat)cellHeightAtRow:(NSInteger)row {
    
    GZEasyTableRow *rowObject = (GZEasyTableRow *)[self childAtIndex:row];
    
    if (rowObject) {
        return rowObject.cellHeight;
    } else {
        NSNumber *rowHeight = [_rowHeightDict objectForKey:@(row)];
        
        if (rowHeight) {
            return rowHeight.floatValue;
        } else {
            return 0;
        }
    }
}

- (void)setCellHeight:(CGFloat)cellHeight atRow:(NSInteger)row {
    GZEasyTableRow *rowObj = (GZEasyTableRow *)[self childAtIndex:row];
//    DLog(@"%fd", cellHeight);
    if (rowObj) {
        rowObj.cellHeight = cellHeight;
    } else {
        if (_rowHeightDict == nil) {
            _rowHeightDict = [[NSMutableDictionary alloc] init];
        }
        [_rowHeightDict setObject:@(cellHeight) forKey:@(row)];
    }
}

- (void)addRow:(GZEasyTableRow *)row {
    [self addChild:row];
}

@end
