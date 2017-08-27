//
//  ViewController.m
//  MVVMTableView1
//
//  Created by zhen gong on 8/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "ProServiceTableView.h"

@interface ViewController ()

@property (nonatomic, strong) ProServiceTableView *proTableView;

@end

@implementation ViewController

- (ProServiceTableView *)proTableView {
    if(_proTableView == nil) {
        CGRect tableRect = CGRectMake(0,44, self.view.frame.size.width, self.view.frame.size.height);
        _proTableView = [[ProServiceTableView alloc] initWithFrame:tableRect];
    }
    return _proTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.proTableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
