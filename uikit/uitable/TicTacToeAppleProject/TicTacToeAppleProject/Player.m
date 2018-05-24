//
//  Player.m
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithLetter:(NSString *)letter {
    self = [self init];
    if (self) {
        _letter = letter;
    }
    return self;
}

@end
