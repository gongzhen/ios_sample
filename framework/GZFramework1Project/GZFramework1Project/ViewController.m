//
//  ViewController.m
//  GZFramework1Project
//
//  Created by gongzhen on 4/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"  
#import <GZFramework1/Logging.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Logging *logger = [[Logging alloc] init];
    [logger setDebug:true];
    [logger log:@"id"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
