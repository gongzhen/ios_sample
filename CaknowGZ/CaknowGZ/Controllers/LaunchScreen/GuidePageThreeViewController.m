//
//  GuidePageThreeViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GuidePageThreeViewController.h"
#import "SignMainViewController.h"

@interface GuidePageThreeViewController ()

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIButton *getStartButton;
@property (strong, nonatomic) UIButton *emergencyCallButton;
@property (assign, nonatomic) NSInteger pageIndex;

@end

@implementation GuidePageThreeViewController

#pragma mark - properties

- (UILabel *)headerLabel {
    if (_headerLabel == nil) {
        _headerLabel = [[UILabel alloc] init];
        [_headerLabel setTextAlignment:NSTextAlignmentCenter];
        [_headerLabel setText:@"AUTOMOTIVE SERVICE AT YOUR FINGERTIPS"];
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
        [_getStartButton setTitle:@"Get start" forState:UIControlStateNormal];
        [_getStartButton setBackgroundImage:[UIImage imageNamed:kColorButtonRed] forState:UIControlStateNormal];
        _getStartButton.userInteractionEnabled = YES;
        [_getStartButton addTarget:self action:@selector(getStartButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getStartButton;
}

- (UIButton *)emergencyCallButton {
    if (_emergencyCallButton == nil) {
        _emergencyCallButton = [[UIButton alloc] init];
        [_emergencyCallButton setTitle:@"Emergency call" forState:UIControlStateNormal];
        [_emergencyCallButton setBackgroundImage:[UIImage imageNamed:kColorButtonBlue] forState:UIControlStateNormal];
    }
    return _emergencyCallButton;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:kBackgroundguidepage03];        
    }
    return _backgroundImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.getStartButton];
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.emergencyCallButton];

    __weak typeof(self) weakSelf = self;
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
    }];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(100.f);
    }];
    
    [self.getStartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260.f);
        make.height.mas_equalTo(44.f);
        make.centerX.equalTo(weakSelf.view.mas_centerX).with.offset(0.f);
        make.centerY.equalTo(weakSelf.view.mas_centerY).with.offset(self.view.bounds.size.height * 1 / 4);
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

- (void)getStartButtonClicked:(id)sender {
    SignMainViewController *signMainViewController = [[SignMainViewController alloc] init];
    [self.navigationController pushViewController:signMainViewController animated:YES];
    
}

@end
