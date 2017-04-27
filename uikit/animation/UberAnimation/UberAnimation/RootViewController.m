//
//  RootViewController.m
//  UberAnimation
//
//  Created by zhen gong on 4/19/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "RootViewController.h"
#import "SplashViewController.h"

@interface RootViewController ()

@property(strong, nonatomic) UIViewController *rootViewController;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootViewController = [[UIViewController alloc] init];
    [self.rootViewController willMoveToParentViewController:nil];
    [self.rootViewController removeFromParentViewController];
    [self.rootViewController.view removeFromSuperview];
    [self.rootViewController didMoveToParentViewController:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
