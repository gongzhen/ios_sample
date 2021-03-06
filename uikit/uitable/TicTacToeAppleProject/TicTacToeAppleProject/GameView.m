//
//  GameView.m
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "GameView.h"
#import "GameState.h"

@interface GameView()

@property (copy,nonatomic) NSArray *tiles;
@property (strong, nonatomic) UIView *horizontalBar1;
@property (strong, nonatomic) UIView *horizontalBar2;
@property (strong, nonatomic) UIView *verticalBar1;
@property (strong, nonatomic) UIView *verticalBar2;

@end

@implementation GameView

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 9; i++) {
            UIButton *tile = [UIButton buttonWithType:UIButtonTypeCustom];
            [tile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
            [tile setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [temp addObject:tile];
            [self addSubview:tile];
        }
        _tiles = temp;
        
        _horizontalBar1 = [UIView new];
        _horizontalBar1.backgroundColor = [UIColor blackColor];
        
        _horizontalBar2 = [UIView new];
        _horizontalBar2.backgroundColor = [UIColor blackColor];
        
        _verticalBar1 = [UIView new];
        _verticalBar1.backgroundColor = [UIColor blackColor];
        
        _verticalBar2 = [UIView new];
        _verticalBar2.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_horizontalBar1];
        [self addSubview:_horizontalBar2];
        [self addSubview:_verticalBar1];
        [self addSubview:_verticalBar2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tileWidth = self.bounds.size.width / 3;
    
    for (int i = 0; i< _tiles.count; i++) {
        UIButton *tile = _tiles[i];
        tile.frame = CGRectMake(tileWidth * (i % 3), tileWidth * (i / 3), tileWidth, tileWidth);
    }
    
    _horizontalBar1.frame = CGRectMake(0, tileWidth, self.bounds.size.width, 3);
    _horizontalBar2.frame = CGRectMake(0, tileWidth * 2, self.bounds.size.width, 3);
    _verticalBar1.frame = CGRectMake(tileWidth, 0, 3, self.bounds.size.width);
    _verticalBar2.frame = CGRectMake(tileWidth * 2, 0, 3, self.bounds.size.width);
}

- (void)drawGameState:(GameState *)gameState {
    for (int i=0; i < gameState.state.count; i++) {
        if (![gameState.state[i] isEqual:[NSNull null]]) {
            Player *playerOnTile = gameState.state[i];
            [_tiles[i] setTitle:playerOnTile.letter
                       forState:UIControlStateNormal];
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}

- (void)reset {
    for (UIButton *tile in _tiles) {
        [tile setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)tileTapped:(UIButton *)sender {
    NSUInteger tileID = [_tiles indexOfObject:sender];
    [self.delegate gameView:self didTapTile:tileID];
}

@end
