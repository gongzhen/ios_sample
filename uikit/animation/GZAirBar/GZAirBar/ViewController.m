//
//  ViewController.m
//  GZAirBar
//
//  Created by Zhen Gong on 9/27/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "ViewController.h"

static double const normalStateHeight = 128.0;
static double const compactStateHeight = 64;
static double const expandedStateHeight = 284;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* firstTableView;
@property (strong, nonatomic) UITableView* secondTableView;
@property (strong, nonatomic) UIView* airBar;
@property (strong, nonatomic) UIView* backgroundView;


//fileprivate var airBar: UIView!
//fileprivate var backgroundView: UIView!
//fileprivate var darkMenuView: MenuView!
//fileprivate var lightMenuView: MenuView!
//fileprivate var normalView: NormalView!
//fileprivate var expandedView: UIView!
//fileprivate var backButton: UIButton!
//fileprivate var barController: BarController!
@end

@implementation ViewController

#pragma mark - Properties

-(UITableView *)firstTableView {
    if(_firstTableView == nil) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _firstTableView.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.9 alpha:1];
        _firstTableView.rowHeight = 80.f;
        _firstTableView.dataSource = self;
    }
    return _firstTableView;
}

-(UITableView *)secondTableView {
    if(_secondTableView == nil) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _secondTableView.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.9 alpha:1];
        _secondTableView.rowHeight = 80.f;
        _secondTableView.dataSource = self;
    }
    return _secondTableView;
}

-(UIView *)backgroundView {
    if(_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _backgroundView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.firstTableView atIndex:0];
    [self.view insertSubview:self.secondTableView atIndex:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
