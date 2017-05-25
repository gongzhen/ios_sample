//
//  TinderView.m
//  TinderLike
//
//  Created by zhen gong on 5/25/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "TinderView.h"
#import "TinderDraggableView.h"

@interface TinderView()
@property(nonatomic, strong) TinderDraggableView *draggableView;
@end

@implementation TinderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self loadDraggableCustomView];
    }
    return self;
}

- (void)loadDraggableCustomView
{
    self.draggableView = [[TinderDraggableView alloc] initWithFrame:CGRectMake(60, 60, 200, 260)];
    [self addSubview:self.draggableView];
}

@end
