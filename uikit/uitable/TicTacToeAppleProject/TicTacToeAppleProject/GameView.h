//
//  GameView.h
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameState;
@class GameView;

@protocol GameViewDelegate <NSObject>

- (void)gameView:(GameView *)gameView didTapTile:(NSUInteger)tile;

@end

@interface GameView : UIView

@property (weak, nonatomic) id <GameViewDelegate> delegate;

- (void)drawGameState:(GameState *)state;

- (void)reset;

@end
