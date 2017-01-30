//
//  LaunchViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/22/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "LaunchViewController.h"
#import "GuideViewController.h"

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
    
    __weak typeof(self) weakSelf = self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
    }];
    
    GuideViewController *guideViewController = [[GuideViewController alloc] init];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:guideViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
