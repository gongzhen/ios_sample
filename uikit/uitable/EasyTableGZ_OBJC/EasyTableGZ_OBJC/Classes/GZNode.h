//
//  GZNode.h
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZNode : NSObject

@property (nonatomic, strong) GZNode *parent;
@property (nonatomic, strong) NSArray *children;

- (void)addChild:(GZNode *)node;
- (GZNode *)childAtIndex:(NSUInteger)index;

- (void)insertChild:(GZNode *)node atIndex:(NSUInteger)index;
@end
