//
//  GameViewController.h
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameState;

@interface GameViewController : UIViewController

- (instancetype)initWithGameState:(GameState *)state;

@end
