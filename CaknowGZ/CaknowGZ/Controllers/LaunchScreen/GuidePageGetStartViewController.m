//
//  GuidePageGetStartViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/26/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GuidePageGetStartViewController.h"
#import "SignMainViewController.h"

@interface GuidePageGetStartViewController ()

@end

@implementation GuidePageGetStartViewController

#pragma mark - properties

- (UILabel *)headerLabel {
    if (_headerLabel == nil) {
        _headerLabel = [[UILabel alloc] init];
        [_headerLabel setTextAlignment:NSTextAlignmentCenter];
        [_headerLabel setTextColor:[UIColor blackColor]];
        [_headerLabel setFont:[UIFont boldSystemFontOfSize: 18.f]];
        _headerLabel.numberOfLines = 0;
        _headerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _headerLabel;
}

- (UIButton *)getStartButton {
    if (_getStartButton == nil) {
        _getStartButton = [[UIButton alloc] init];
        [_getStartButton setBackgroundImage:[UIImage imageNamed:kColorButtonRed] forState:UIControlStateNormal];
        [_getStartButton addTarget:self action:@selector(getStartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getStartButton;
}

- (UIButton *)emergencyCallButton {
    if (_emergencyCallButton == nil) {
        _emergencyCallButton = [[UIButton alloc] init];
        [_emergencyCallButton setBackgroundImage:[UIImage imageNamed:kColorButtonBlue] forState:UIControlStateNormal];
    }
    return _emergencyCallButton;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];

    }
    return _backgroundImageView;
}

#pragma mark - lifecyle 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.headerLabel];
    [self.backgroundImageView addSubview:self.getStartButton];
    [self.backgroundImageView addSubview:self.emergencyCallButton];
    __weak typeof(self) weakSelf = self;
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
    }];

    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60.f);
        make.left.equalTo(weakSelf.backgroundImageView.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.backgroundImageView.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.backgroundImageView.mas_top).with.offset(100.f);
    }];
    
    [self.getStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260.f);
        make.height.mas_equalTo(44.f);
        make.centerX.equalTo(weakSelf.backgroundImageView.mas_centerX).with.offset(0.f);
        make.centerY.equalTo(weakSelf.backgroundImageView.mas_centerY).with.offset(self.view.bounds.size.height * 1 / 4);
    }];
    
    [self.emergencyCallButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.getStartButton.mas_width);
        make.height.equalTo(weakSelf.getStartButton.mas_height);
        make.centerX.equalTo(weakSelf.getStartButton.mas_centerX).with.offset(0.f);
        make.top.equalTo(weakSelf.getStartButton.mas_bottom).with.offset(20.f);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)getStartButtonClicked:(UIButton *)sender {
    SignMainViewController *signMainViewController = [[SignMainViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signMainViewController];
    [navigationController pushViewController:navigationController animated:YES];
}

@end
