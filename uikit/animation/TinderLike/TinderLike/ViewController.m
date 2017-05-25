//
//  ViewController.m
//  TinderLike
//
//  Created by zhen gong on 5/25/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "TinderView.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView
{
    self.view = [[TinderView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
