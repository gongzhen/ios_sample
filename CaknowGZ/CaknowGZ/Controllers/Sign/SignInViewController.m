//
//  SignInViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 2/2/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "SignInViewController.h"
#import "GarageViewController.h"
#import "PostConsumerEntity.h"

@interface SignInViewController () //<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) UILabel *sloganLabel;
@property (strong, nonatomic) UIView *emailView;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UIImageView *iconEmailView;
@property (strong, nonatomic) UIView *passwordView;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIImageView *iconPasswordView;
@property (strong, nonatomic) UIButton *signInButton;
@property (strong, nonatomic) UIButton *forgetPasswordButton;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *forgetPasswordWarningImage;

@end

@implementation SignInViewController

#pragma mark - properties

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:kBackgroundSignUp];
        [_backgroundImageView setOpaque:YES];
    }
    return _backgroundImageView;
}

- (UIView *)emailView {
    if (_emailView == nil) {
        _emailView = [[UIView alloc] init];
        [_emailView setBackgroundColor:[UIColor lightGrayColor]];
        [_emailView setOpaque:YES];
    }
    return _emailView;
}

- (UIImageView *)iconEmailView {
    if (_iconEmailView == nil) {
        _iconEmailView = [[UIImageView alloc] init];
        _iconEmailView.image = [UIImage imageNamed:kIconEmail];
        [_iconEmailView setOpaque:YES];
    }
    return _iconEmailView;
}

- (UITextField *)emailTextField {
    if (_emailTextField == nil) {
        _emailTextField = [[UITextField alloc] init];
        [_emailTextField setPlaceholder:@"Email Address"];
        _emailTextField.delegate = self;
        [_emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_emailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_emailTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_emailTextField setTextColor:[UIColor blackColor]];
        [_emailTextField setUserInteractionEnabled:YES];
        [_emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
    return _emailTextField;
}

- (UIView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[UIView alloc] init];
        _passwordView.contentMode = UIViewContentModeScaleToFill;
        [_passwordView setBackgroundColor:[UIColor lightGrayColor]];
        [_passwordView setOpaque:YES];
    }
    return _passwordView;
}

- (UIImageView *)iconPasswordView {
    if (_iconPasswordView == nil) {
        _iconPasswordView = [[UIImageView alloc] init];
        _iconPasswordView.image = [UIImage imageNamed:kIconPassword];
        [_iconPasswordView setOpaque:YES];
    }
    return _iconPasswordView;
}

- (UITextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.delegate = self;
        [_passwordTextField setPlaceholder:@"Password"];
        [_passwordTextField setUserInteractionEnabled:YES];
        [_passwordTextField setOpaque:YES];
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        [_passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_passwordTextField setSpellCheckingType:UITextSpellCheckingTypeNo];
        [_passwordTextField setTextAlignment:NSTextAlignmentLeft];
        [_passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_passwordTextField setReturnKeyType:UIReturnKeyGo];
        [_passwordTextField setSecureTextEntry:YES];
    }
    return _passwordTextField;
}

- (UILabel *)sloganLabel {
    if (_sloganLabel == nil) {
        _sloganLabel = [[UILabel alloc] init];
        [_sloganLabel setTextAlignment:NSTextAlignmentCenter];
        [_sloganLabel setText:@"Welcome back"];
        [_sloganLabel setTextColor:[UIColor blackColor]];
    }
    return _sloganLabel;
}

- (UIButton *)signInButton {
    if (_signInButton == nil) {
        _signInButton = [[UIButton alloc] init];
        [_signInButton setBackgroundImage:[UIImage imageNamed:kColorButtonRed] forState:UIControlStateNormal];
        [_signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
        [_signInButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_signInButton addTarget:self action:@selector(signInButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signInButton;
}

- (UIButton *)forgetPasswordButton {
    if (_forgetPasswordButton == nil) {
        _forgetPasswordButton = [[UIButton alloc] init];
        [_forgetPasswordButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
//        [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}

- (UIImageView *)forgetPasswordWarningImage {
    if (_forgetPasswordWarningImage == nil) {
        _forgetPasswordWarningImage = [[UIImageView alloc] init];
        _forgetPasswordWarningImage.image = [UIImage imageNamed:kIconWarning];
        [_forgetPasswordWarningImage setOpaque:YES];
    }
    return _forgetPasswordWarningImage;
}

#pragma mark - lifecycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewConstraint];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action

- (void)signInButtonClicked:(UIButton *)sender {
    _signInButton.enabled = NO;
    [[CaknowClient sharedInstance] loginWithUsername:_emailTextField.text
                                            password:_passwordTextField.text
                                          completion:^(Boolean verified, NSError *error) {
        if (error) {
            DLog(@"%@", error);
        } else if (!verified) {
            DLog(@"verified is false: %d", verified);
        } else {
            DLog(@"verified is true: %d", verified);
            // go to garageviewcontroller
            GarageViewController *garageViewController = [[GarageViewController alloc] init];
            if (!garageViewController) {
                return;
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UINavigationController *nav = (UINavigationController *)self.presentingViewController;
                [self dismissViewControllerAnimated:YES completion:^{
                    [nav presentViewController:garageViewController animated:YES completion:nil];
                }];
            }];
        }
    }];
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_passwordTextField == textField ) {
        [self signInButtonClicked:_signInButton];
    }
    return YES;
}

#pragma mark -  UIViewControllerTransitioningDelegate

//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    
//}
//
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    
//}

#pragma mark - helper method

-(void)setupViewConstraint {
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.sloganLabel];
    
    [self.view addSubview:self.emailView];
    [self.emailView addSubview:self.iconEmailView];
    [self.emailView addSubview:self.emailTextField];
    
    [self.view addSubview:self.passwordView];
    [self.passwordView addSubview:self.iconPasswordView];
    [self.passwordView addSubview:self.passwordTextField];
    [self.view addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton addSubview:self.forgetPasswordWarningImage];
    
    [self.view addSubview:self.signInButton];
    
    __weak typeof(self) weakSelf = self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
    }];
    
    [self.sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(100.f);
    }];
    
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.sloganLabel.mas_bottom).with.offset(10.f);
    }];

    [self.iconEmailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.emailView.mas_height);
        make.width.mas_equalTo(weakSelf.emailView.mas_height);
        make.top.equalTo(weakSelf.emailView.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.emailView.mas_left).with.offset(0.f);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconEmailView.mas_right).with.offset(0.f);
        make.top.equalTo(weakSelf.emailView.mas_top).with.offset(0.f);
        make.right.equalTo(weakSelf.emailView.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.emailView.mas_bottom).with.offset(0.f);
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.emailView.mas_bottom).with.offset(2.f);
    }];

    [self.iconPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(weakSelf.passwordView.mas_height);
        make.width.mas_equalTo(weakSelf.passwordView.mas_height);
        make.left.equalTo(weakSelf.passwordView.mas_left).with.offset(0.f);
        make.top.equalTo(weakSelf.passwordView.mas_top).with.offset(0.f);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconPasswordView.mas_right).with.offset(0.f);
        make.top.equalTo(weakSelf.passwordView.mas_top).with.offset(0.f);
        make.right.equalTo(weakSelf.passwordView.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.passwordView.mas_bottom).with.offset(0.f);
    }];

    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(10.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(self.view.bounds.size.width * 1 / 2);
        make.top.equalTo(weakSelf.passwordView.mas_bottom).with.offset(10.f);
    }];
    
    [self.forgetPasswordWarningImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15.f);
        make.height.mas_equalTo(15.f);
        make.left.equalTo(weakSelf.forgetPasswordButton.mas_left).with.offset(10.f);
        make.centerY.equalTo(weakSelf.forgetPasswordButton.mas_centerY).with.offset(0.f);
    }];
    
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.f);
        make.top.equalTo(weakSelf.forgetPasswordButton.mas_bottom).with.offset(5.f);
    }];
    
}

@end
