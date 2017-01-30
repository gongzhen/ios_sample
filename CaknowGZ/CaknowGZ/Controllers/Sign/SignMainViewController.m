//
//  SignMainViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "SignMainViewController.h"

@interface SignMainViewController () <FBSDKLoginButtonDelegate>
{
    FBSDKLoginManager *_fbLoginManager;
    FBSDKLoginButton *_fbButton;
}

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property(strong, nonatomic) UIButton *loginButton;
@property(strong, nonatomic) UIButton *signUpButton;
@property(strong, nonatomic) UIButton *signInFacebookButton;
@property(strong, nonatomic) UIButton *signInGoogleButton;

@end

@implementation SignMainViewController

#pragma mark - properties

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:kBgLogin];
    }
    return _backgroundImageView;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setBackgroundImage:[UIImage imageNamed:kBgLogin] forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UIButton *)signUpButton {
    if (_signUpButton == nil) {
        _signUpButton = [[UIButton alloc] init];
        [_signUpButton setBackgroundImage:[UIImage imageNamed:kColorButtonBlue] forState:UIControlStateNormal];
    }
    return _signUpButton;
}

//- (UIButton *)signInFacebookButton {
//    
//}
//
//- (UIButton *)signInGoogleButton {
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareViews];
    [self setupConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareViews {
    [self.view addSubview:self.backgroundImageView];
    
    _fbButton = [FBSDKLoginButton new];
    _fbButton.bounds = CGRectMake(0, 0, 260, 40);
    _fbButton.delegate = self;
    [self.backgroundImageView addSubview:_fbButton];
    [self.backgroundImageView addSubview:self.loginButton];
    [self.backgroundImageView addSubview:self.signUpButton];
}

- (void) setupConstraints {
    
    __weak typeof(self) weakSelf = self;
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.backgroundImageView.mas_top).with.offset(40.f);
        make.right.equalTo(weakSelf.backgroundImageView.mas_right).with.offset(-20.f);
        make.width.mas_equalTo(210.f);
        make.height.mas_equalTo(35.f);
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backgroundImageView.mas_centerY).with.offset(0.f);
        make.height.mas_equalTo(40.f);
        make.width.mas_equalTo(40.f);
    }];
}

#pragma mark - facebook delegate method

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    

}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {

}


@end
