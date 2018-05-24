//
//  GameState.h
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface GameState : NSObject

enum GameStateStatus : NSUInteger {
    GameStatusInPlay = 1,
    GameStatusPlayerXWon = 2,
    GameStatusPlayerOWon = 3,
    GameStatusDraw = 4
};

@property (strong, nonatomic, readonly) Player *playerX;
@property (strong, nonatomic, readonly) Player *playerO;
@property (copy, nonatomic, readonly) NSArray *state; // The board represented as an array of size 9
@property (strong, nonatomic, readonly) Player *currentPlayer;
@property (nonatomic, readonly) enum GameStateStatus status;

- (instancetype)initWithPlayerX:(Player *)playerX playerO:(Player *)playerO;

- (BOOL)isNewGame;

- (GameState *)makeMove:(NSUInteger)move;

// Valid moves. The keys are the indeces of the tiles and the values are the next state
- (NSDictionary *)moves;

@end
