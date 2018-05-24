//
//  Player.h
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (copy, nonatomic) NSString *letter;

- (instancetype)initWithLetter:(NSString *)letter;

@end
