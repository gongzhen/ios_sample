//
//  GameState.m
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "GameState.h"

@interface GameState ()

@property (strong, nonatomic) Player *playerX;
@property (strong, nonatomic) Player *playerO;
@property (copy, nonatomic) NSArray *state;
@property (strong, nonatomic) Player *currentPlayer;
@property (nonatomic) enum GameStateStatus status;

@end

@implementation GameState

- (instancetype)init {
    self = [super init];
    if (self) {
        // The board
        _state = @[[NSNull null], [NSNull null], [NSNull null],
                   [NSNull null], [NSNull null], [NSNull null],
                   [NSNull null], [NSNull null], [NSNull null]];
        _status = GameStatusInPlay;
    }
    
    return self;
}

- (instancetype)initWithPlayerX:(Player *)playerX playerO:(Player *)playerO {
    self = [self init];
    if (self) {
        _currentPlayer = playerX;
        _playerO = playerO;
        _playerX = playerX;
    }
    
    return self;
}

- (instancetype)initWithPlayerX:(Player *)playerX
                        playerO:(Player *)playerO
                          state:(NSArray *)state
                  currentPlayer:(Player *)currentPlayer {
    self = [self initWithPlayerX:playerX playerO:playerO];
    if (self) {
        _state = state;
        _currentPlayer = currentPlayer;
    }
    _status = [self determineStatus];
    
    return self;
}

- (enum GameStateStatus)determineStatus {
    if ([self didPlayerWin:_playerX]) {
        return GameStatusPlayerXWon;
    } else if ([self didPlayerWin:_playerO]) {
        return GameStatusPlayerOWon;
    } else if ([self canStillMove]) {
        return GameStatusInPlay;
    } else {
        return GameStatusDraw;
    }
}

- (BOOL)didPlayerWin:(Player *)player {
    // Horizontal
    for (int i = 0; i < 3; i++) {
        if (_state[i * 3] == player &&
            _state[1 + i * 3] == player &&
            _state[2 + i * 3] == player) {
            return true;
        }
    }
    
    // Vertical
    for (int i = 0; i < 3; i++) {
        if (_state[i] == player &&
            _state[i + 3] == player &&
            _state[i + 6] == player) {
            return true;
        }
    }
    
    // Diagonal
    if (_state[0] == player &&
        _state[4] == player &&
        _state[8] == player) {
        return true;
    } else if (_state[2] == player &&
               _state[4] == player &&
               _state[6] == player) {
        return true;
    }
    return false;
}

- (BOOL)canStillMove {
    for (NSString *move in _state) {
        if ([[NSNull null] isEqual:move]) {
            return true;
        }
    }
    return false;
}

- (NSDictionary *)moves {
    NSMutableDictionary *temp = [NSMutableDictionary new];
    if (_status == GameStatusInPlay) {
        for (int i = 0; i< _state.count; i++) {
            if ([[NSNull null] isEqual:_state[i]]) { // Valid move
                Player *nextPlayer = _currentPlayer == _playerX ? _playerO : _playerX;
                NSMutableArray *nextState = [_state mutableCopy];
                nextState[i] = _currentPlayer;
                GameState *newState = [[GameState alloc] initWithPlayerX:_playerX
                                                                       playerO:_playerO
                                                                         state:nextState
                                                                 currentPlayer:nextPlayer];
                temp[@(i)] = newState;
            }
        }
    }
    return temp;
}

- (GameState *)makeMove:(NSUInteger)move {
    return [self moves][@(move)];
}

- (BOOL)isNewGame {
    return [self moves].count == 9;
}

@end
