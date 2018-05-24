//
//  GameViewController.m
//  TicTacToeAppleProject
//
//  Created by Zhen Gong on 5/12/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "GameViewController.h"
#import "GameState.h"
#import "GameView.h"
#import "PlayerAI.h"
#import "Player.h"


@interface GameViewController () <GameViewDelegate>

@property (strong, nonatomic) GameState *gameTree; // The game tree - each node is a game state
@property (strong, nonatomic) GameState *currentState; // Current node in game state tree
@property (strong, nonatomic) GameView *gameView;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UIButton *dismissGameButton;
@property (strong, nonatomic) UILabel *gameStatusLabel;

@end

@implementation GameViewController

- (instancetype)initWithGameState:(GameState *)state {
    self = [self init];
    if (self) {
        _gameTree = state;
        _currentState = state;
    }
    return self;
}


- (void)loadView {
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _gameView = [GameView new];
    _gameView.delegate = self;
    
    _gameStatusLabel = [UILabel new];
    _gameStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetButton addTarget:self
                     action:@selector(resetGame)
           forControlEvents:UIControlEventTouchUpInside];
    
    _dismissGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_dismissGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [_dismissGameButton addTarget:self
                           action:@selector(dismissGame)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_gameView];
    [self.view addSubview:_gameStatusLabel];
    [self.view addSubview:_dismissGameButton];
    [self.view addSubview:_resetButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGFloat gameDimension = self.view.frame.size.width - 30;

    _gameView.frame = CGRectMake(15, 64, gameDimension, gameDimension);
    
    _gameStatusLabel.frame = CGRectMake(0,
                                        CGRectGetMaxY(_gameView.frame) + 15,
                                        self.view.frame.size.width,
                                        20);
    
    _dismissGameButton.frame = CGRectMake(0,
                                          self.view.frame.size.height - 100,
                                          self.view.frame.size.width / 2,
                                          100);
    
    _resetButton.frame = CGRectMake(self.view.frame.size.width / 2,
                                    self.view.frame.size.height - 100,
                                    self.view.frame.size.width / 2,
                                    100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetGame {
    [_gameView reset]; // Reset view
    _currentState = _gameTree; // Reset game state
    [self displayGameStatusText];
    [self playAI];
}

- (void)dismissGame {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GameViewDelegate

- (void)gameView:(GameView *)gameView didTapTile:(NSUInteger)tile {
    if ([_currentState.currentPlayer isKindOfClass:[PlayerAI class]]) return;
    GameState *nextState = [_currentState makeMove:tile];
    if (nextState) {
        [self displayNextState:nextState];
        if ([nextState.currentPlayer isKindOfClass:[PlayerAI class]]) {;
            [self playAI];
        }
    }
}

- (void)playAI {
    if (_currentState.status == GameStatusInPlay &&
        [_currentState.currentPlayer isKindOfClass:[PlayerAI class]]) {
        PlayerAI *playerAI = (PlayerAI *)_currentState.currentPlayer;
        
        // Run Min Max in background since otherwise it will hog the UI thread
        __weak GameViewController *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            GameState *bestMove = [playerAI bestMoveForGameState:weakSelf.currentState];
            [bestMove.state enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DLog(@"%@", obj);
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf displayNextState:bestMove];
            });
        });
    }
}

- (void)displayNextState:(GameState *)nextState {
    if (nextState) {
        _currentState = nextState;
        [_gameView drawGameState:nextState];
        
        [self displayGameStatusText];
    }
}

- (void)displayGameStatusText {
    switch (_currentState.status) {
        case GameStatusDraw:
            _gameStatusLabel.text = @"Draw!";
            break;
        case GameStatusPlayerXWon:
            _gameStatusLabel.text = @"Player X Won!";
            break;
        case GameStatusPlayerOWon:
            _gameStatusLabel.text = @"Player O Won!";
            break;
        default:
            _gameStatusLabel.text = [NSString stringWithFormat:@"Player %@'s Move", _currentState.currentPlayer.letter];
            break;
    }
}
@end
