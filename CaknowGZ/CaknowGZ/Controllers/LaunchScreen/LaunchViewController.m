//
//  LaunchViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/22/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "LaunchViewController.h"
#import "GuideViewController.h"
#import "SignMainViewController.h"
#import "GarageViewController.h"

@interface LaunchViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation LaunchViewController

#pragma mark - Properties

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:kBackgroundLaunchScreen];
    }
    return _backgroundImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundImageView];
    [[CaknowClient sharedInstance] removeAccessToken];
    __weak typeof(self) weakSelf = self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
    }];
    // test code from SigninViewController start
//    GarageViewController *garageViewController = [[GarageViewController alloc] init];
//    if (!garageViewController) {
//        return;
//    }
//    self.navigationController.navigationBarHidden = YES;
//    [self.navigationController pushViewController:garageViewController animated:YES];
    // test code from SigninViewController end
    
    SignMainViewController *signMainViewController = [[SignMainViewController alloc] init];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:signMainViewController animated:YES];

//        GuideViewController *guideViewController = [[GuideViewController alloc] init];
//        self.navigationController.navigationBarHidden = YES;
//        [self.navigationController pushViewController:guideViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
