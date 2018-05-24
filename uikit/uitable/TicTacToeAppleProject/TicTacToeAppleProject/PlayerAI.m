//
//  PlayerAI.m
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "PlayerAI.h"
#import "GameState.h"

@implementation PlayerAI

- (GameState *)bestMoveForGameState:(GameState *)state {
    // If first player to go, play anything to speed up game
    DLog(@"state.status:%ld", state.status);
    if ([state isNewGame]) {
        return [state makeMove:arc4random_uniform(9)];
    }
    // Maximise move scores using min max algo to determine the best move
    GameState *bestMove;
    int bestRank = -99;
    for (GameState *move in [state moves].allValues) {
        int rank = [self minMaxForForGameState:move];
        if (rank > bestRank) {
            bestMove = move;
            bestRank = rank;
        }
    }
    return bestMove;
}

- (int)minMaxForForGameState:(GameState *)state{
    if (state.status != GameStatusInPlay) {
        return [self rankForGameState:state];
    }
    // Recursively descend game tree to obtain best ranks for each move
    NSMutableArray *ranks = [NSMutableArray new];
    for (GameState *move in [state moves].allValues) {
        DLog(@"move:%@", move.currentPlayer.letter);
        int rank = [self minMaxForForGameState:move];
        [ranks addObject:[NSNumber numberWithInt:rank]];
    }
    
    int bestRank = [ranks.firstObject intValue];
    for (NSNumber *rank in ranks) {
        int currentRank = [rank intValue];
        if (self == state.currentPlayer) { // MAX
            if (currentRank > bestRank) {
                bestRank = currentRank;
            }
        } else { // MIN
            if (currentRank < bestRank) {
                bestRank = currentRank;
            }
        }
    }
    return bestRank;
}

// The value of the given state. +10 if it's a win, -10 for a lose, and 0 for a draw
- (int)rankForGameState:(GameState *)state{
    switch (state.status) {
        case GameStatusDraw:
            return 0;
        case GameStatusPlayerXWon:
            return self == state.playerX ? 10 : - 10;
        case GameStatusPlayerOWon:
            return self == state.playerO ? 10 : - 10;
        default:
            return 0;
    }
}

@end
