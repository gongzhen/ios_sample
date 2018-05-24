//
//  PlayerAI.h
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "Player.h"

@class GameState;

@interface PlayerAI : Player

- (GameState *)bestMoveForGameState:(GameState *)state;


@end
