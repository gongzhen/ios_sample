//
//  GZEasyTableModel.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "GZEasyTableModel.h"
#import "GZEasyTableSection.h"
#import "GZEasyTableRow.h"

@implementation GZEasyTableModel

- (void)setSectionsWithModels:(NSArray *)sectionModels {
    [self setSectionsWithModels:sectionModels attributeSetter:nil];
}

// block is a function defition without a function name.
// NSDctionary* (^)(id) is a block that return a NSDictionary with parameter as id
// block returns a NSDictionary type dictioanry and accept a single id model parameter.
// In implementation file, setterBlock(id model) returns a NSDictioanry dict.
- (void)setSectionsWithModels:(NSArray *)sectionModels attributeSetter:(NSDictionary *(^)(id))setterBlock {
    if (sectionModels.count) {
        for (id model in sectionModels) {
            NSDictionary *attributes = nil;
            if (setterBlock) {
                DLog(@"setterBlock %@", setterBlock);
                setterBlock(model);
            }
            // table section initializer with model and attributes
            DLog(@"model: %@", model);
            GZEasyTableSection *section = [[GZEasyTableSection alloc] initWithModel:model attributes:attributes];
            // GZNode addChild: ssection
            [self addChild:section];
            
        }
        DLog(@"children section count: %lu", (unsigned long)self.children.count);
    }
}

- (NSInteger)numberOfSections {
    return self.children.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    GZEasyTableSection *sectionObj = (GZEasyTableSection *)[self childAtIndex:section];
    
    if (sectionObj) {
        // DLog(@"numberOfRowsInSection: %ld", (long)[sectionObj numberOfRows]);
        return [sectionObj numberOfRows];
    }
    return 0;
}

- (void)setCellHeight:(CGFloat)cellHeight atIndexPath:(NSIndexPath *)indexPath {
    GZEasyTableSection *section = [self sectionAtIndex:indexPath.section];
    [section setCellHeight:cellHeight atRow:indexPath.row];
}

- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    // self sectionAtIndex: indexPath.section
    GZEasyTableSection *section = [self sectionAtIndex:indexPath.section];
    return [section cellHeightAtRow:indexPath.row];
}

- (GZEasyTableSection *)sectionAtIndex:(NSInteger)index {
    GZEasyTableSection *section = (GZEasyTableSection *)[self childAtIndex:index];
    return section;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    GZEasyTableSection *section = (GZEasyTableSection *)[self childAtIndex:indexPath.section];
    DLog(@"section %@", section);
    if (section) {
        GZEasyTableRow *row = (GZEasyTableRow *)[section childAtIndex:indexPath.row];
        DLog(@"row: %@", row);
        if (row) {
            return row.model;
        } else {
            return section.model;
        }
    }
    return nil;
}


@end
