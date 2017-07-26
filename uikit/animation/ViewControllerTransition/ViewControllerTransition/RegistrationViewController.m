//
//  RegistrationViewController.m
//  ViewControllerTransition
//
//  Created by zhen gong on 7/15/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@property(strong, nonatomic) UIButton *btn;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 20)];
    self.btn.backgroundColor = [UIColor blackColor];
    [self.btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)btnPressed:(UIButton *)sender {
    [self.delegate registerProfessionalUser:@{@"user": @"gongzhen"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
