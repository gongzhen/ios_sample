//
//  ViewController.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ViewController.h"
#import "Webservice.h"
#import "ProListViewModel.h"

@interface ViewController ()

@property(strong, nonatomic) Webservice* webService;
@property(strong, nonatomic) ProListViewModel* proListViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webService = [[Webservice alloc] init];
    self.proListViewModel = [[ProListViewModel alloc] initWithService:self.webService];
    [self.proListViewModel getProList:^(NSArray * proList) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
