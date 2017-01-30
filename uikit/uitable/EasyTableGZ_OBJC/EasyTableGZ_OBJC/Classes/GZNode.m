//
//  GZNode.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "GZNode.h"

@interface GZNode() {
    @private
    NSMutableArray *_children;
    GZNode *_parent;
}

@end

@implementation GZNode

- (void)addChild:(GZNode *)node {
    if (node) {
        node.parent = self;
        @synchronized (self) {
            if (_children == nil) {
                _children = [[NSMutableArray alloc] init];
            }
            DLog(@"_children addObject node: %@", node);
            [_children addObject:node];
        }
    }
    DLog(@"_children count: %lu", (unsigned long)_children.count);
}

- (GZNode *)childAtIndex:(NSUInteger)index {
    NSArray *children = self.children;
    return children.count > index ? [children objectAtIndex:index] : nil;
}

- (void)insertChild:(GZNode *)node atIndex:(NSUInteger)index {
    if (node && index <= _children.count) {
        node.parent = self;
        @synchronized (self) {
            if (!_children) {
                _children = [[NSMutableArray alloc] init];
            }
            [_children insertObject:node atIndex:index];
        }
    }
}

@end
