//
//  ViewController.m
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "Player.h"
#import "PlayerAI.h"
#import "GameState.h"

@interface ViewController ()

@property (strong, nonatomic) UILabel *labelX;
@property (strong, nonatomic) UILabel *labelO;
@property (strong, nonatomic) UISegmentedControl *playerXChoice;
@property (strong, nonatomic) UISegmentedControl *playerOChoice;
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _labelX = [UILabel new];
    _labelX.text = @"Player X";
    _labelX.textAlignment = NSTextAlignmentCenter;
    
    _labelO = [UILabel new];
    _labelO.text = @"Player O";
    _labelO.textAlignment = NSTextAlignmentCenter;
    
    _playerXChoice = [[UISegmentedControl alloc] initWithItems:@[@"Player", @"AI"]];
    _playerXChoice.selectedSegmentIndex = 0;
    [_playerXChoice addTarget:self
                       action:@selector(didSelectPlayer)
             forControlEvents:UIControlEventValueChanged];
    
    _playerOChoice = [[UISegmentedControl alloc] initWithItems:@[@"Player", @"AI"]];
    _playerOChoice.selectedSegmentIndex = 0;
    [_playerOChoice addTarget:self
                       action:@selector(didSelectPlayer)
             forControlEvents:UIControlEventValueChanged];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startButton setTitle:@"Let's do this!" forState:UIControlStateNormal];
    [_startButton addTarget:self
                     action:@selector(startGame)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_labelX];
    [self.view addSubview:_playerXChoice];
    [self.view addSubview:_labelO];
    [self.view addSubview:_playerOChoice];
    [self.view addSubview:_startButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _labelX.frame = CGRectMake(self.view.frame.size.width / 2 - 100,
                               100,
                               200,
                               50);
    
    _playerXChoice.frame = CGRectMake(self.view.frame.size.width / 2 - 100,
                                      150,
                                      200,
                                      50);
    
    _labelO.frame = CGRectMake(self.view.frame.size.width / 2 - 100,
                               250,
                               200,
                               50);
    
    _playerOChoice.frame = CGRectMake(self.view.frame.size.width / 2 - 100,
                                      300,
                                      200,
                                      50);
    
    _startButton.frame = CGRectMake(0,
                                    self.view.frame.size.height - 100,
                                    self.view.frame.size.width,
                                    100);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectPlayer {
    // Must have at least one non-AI player
    if (_playerXChoice.selectedSegmentIndex == 0 || _playerOChoice.selectedSegmentIndex == 0) {
        _startButton.enabled = YES;
    } else {
        _startButton.enabled = NO;
    }
}

- (void)startGame {
    Player *playerX, *playerO;
    if (_playerXChoice.selectedSegmentIndex == 0) {
        playerX = [[Player alloc] initWithLetter:@"X"];
    } else {
        playerX = [[PlayerAI alloc] initWithLetter:@"X"];
    }
    
    if (_playerOChoice.selectedSegmentIndex == 0) {
        playerO = [[Player alloc] initWithLetter:@"O"];
    } else {
        playerO = [[PlayerAI alloc] initWithLetter:@"O"];
    }
    
    GameState *game = [[GameState alloc] initWithPlayerX:playerX playerO:playerO];
    GameViewController *gameVC = [[GameViewController alloc] initWithGameState:game];
    [self presentViewController:gameVC animated:YES completion:nil];
}


@end
