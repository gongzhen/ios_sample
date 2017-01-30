//
//  ViewController.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/12/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "FBSDKLoginButton.h"

@interface ViewController ()

// @property (strong, nonatomic)

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view, typically from a nib.
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    CGRect buttonFrame = loginButton.frame;
    buttonFrame.size = CGSizeMake(300.f, 100.f);
    loginButton.frame = buttonFrame;
    loginButton.center = self.view.center;
    [loginButton setBackgroundColor:[UIColor colorWithRed:65.0/255.0 green:93.0/255.0 blue:174.0/255.0 alpha:1.0]];
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
