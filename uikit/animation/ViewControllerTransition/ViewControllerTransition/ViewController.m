//
//  ViewController.m
//  ViewControllerTransition
//
//  Created by zhen gong on 7/14/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "ProfessionalRegistrationViewController.h"
#import "RegistrationViewController.h"

@interface ViewController () <RegistrationDelegate>

@property(strong, nonatomic)ProfessionalRegistrationViewController *prController;
@property(strong, nonatomic)UIView* currentView, *previousView;

@end

@implementation ViewController

#pragma mark - life cycle

- (instancetype)init {
    if(self = [super init]) {
        _prController = [[ProfessionalRegistrationViewController alloc] init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RegistrationDelegate

- (void)registerProfessionalUser:(NSDictionary *)userObject {
    [self professionalRegistrationFlow:userObject];
}

- (void)professionalRegistrationFlow:(NSDictionary *)user {
    self.currentView = self.prController.view;
    [self viewTransition];
}

- (void)viewTransition {
    if (self.currentView == self.previousView) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionFromView:self.previousView toView:self.currentView duration:0.3f options:(UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionCrossDissolve) completion:^(BOOL finished) {
            self.previousView = self.currentView;
        }];
    });
}



@end
