//
//  SignMainViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "SignMainViewController.h"
#import "SignInViewController.h"

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
        [_loginButton setTitle:@"Login in" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor clearColor]];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[_loginButton layer] setBorderWidth:2.f];
        [[_loginButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [_loginButton addTarget:self action:@selector(signInButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)signUpButton {
    if (_signUpButton == nil) {
        _signUpButton = [[UIButton alloc] init];
        [_signUpButton setBackgroundImage:[UIImage imageNamed:kColorButtonBlue] forState:UIControlStateNormal];
        [_signUpButton setTitle:@"Sign up with email" forState:UIControlStateNormal];
    }
    return _signUpButton;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareViews];
    [self setupConstraints];
    [self setupFacebookPermission];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isUserLoggedIn]) {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareViews {
    [self.view addSubview:self.backgroundImageView];
    _fbButton = [FBSDKLoginButton new];
    _fbButton.delegate = self;
    [self.view addSubview:_fbButton];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.signUpButton];
}

- (void)setupFacebookPermission {
    _fbButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

#pragma mark - facebook delegate method

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil && result.isCancelled != YES) {
        
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

#pragma mark - private methods

- (BOOL)isUserLoggedIn {
    return [FBSDKAccessToken currentAccessToken] != nil;
}

- (void)signInButtonClicked:(UIButton *)sender {
    SignInViewController *signInViewController = [[SignInViewController alloc] init];
    UINavigationController *signInNavigationController = [[UINavigationController alloc] initWithRootViewController:signInViewController];
    [self presentViewController:signInNavigationController animated:YES completion:^{
        
    }];
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
        make.width.mas_equalTo(85.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX).with.offset(0.f);
        make.centerY.equalTo(weakSelf.view.mas_centerY).with.offset(0.f);
        make.height.mas_equalTo(40.f);
        make.width.mas_equalTo(260.f);
    }];
    [_fbButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.signUpButton.mas_bottom).with.offset(10.f);
        make.width.equalTo(weakSelf.signUpButton.mas_width);
        make.height.equalTo(weakSelf.signUpButton.mas_height);
        make.centerX.equalTo(weakSelf.view.mas_centerX).with.offset(0.f);
    }];
}

@end
