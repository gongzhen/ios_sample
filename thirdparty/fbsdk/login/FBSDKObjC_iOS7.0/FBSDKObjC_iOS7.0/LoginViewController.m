//
//  LoginViewController.m
//  FBSDKObjc_iOS7.0
//
//  Created by gongzhen on 12/22/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "AlertControllerUtility.h"

@interface LoginViewController()<FBSDKLoginButtonDelegate>

@property (nonatomic, strong) FBSDKLoginButton *fbLoginButton;

@property (nonatomic, strong) UIButton *customLoginButton;

@end

@implementation LoginViewController

// facebook button login
- (FBSDKLoginButton *)fbLoginButton {
    if (_fbLoginButton == nil) {
        _fbLoginButton = [[FBSDKLoginButton alloc] init];
        _fbLoginButton.delegate = self;
        _fbLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
        [_fbLoginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _fbLoginButton;
}

// custom button logged in as facebook user.
- (UIButton *)customLoginButton {
    if (_customLoginButton == nil) {
        _customLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_customLoginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_customLoginButton setBackgroundColor:[UIColor darkGrayColor]];
        [_customLoginButton setTitle:@"Facebook Login" forState:UIControlStateNormal];
        [_customLoginButton addTarget:self action:@selector(loginAsFacebookClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customLoginButton;
}

- (void)loginAsFacebookClicked:(UIButton *)sender {
    
    void(^loginHandler)(FBSDKLoginManagerLoginResult *result, NSError *error) = ^(FBSDKLoginManagerLoginResult *result, NSError *error){
        UIAlertController *alertController;
        if (error) {
            alertController = [AlertControllerUtility alertControllerWithTitle:@"Login Fail"
                                                                       message:[NSString stringWithFormat:@"Login fail with error: %@", error]];
        } else if (!result || result.isCancelled) {
            alertController = [AlertControllerUtility alertControllerWithTitle:@"Login Cancelled" message:[NSString stringWithFormat:@"User cancelled login"]];
        } else {
            alertController = [AlertControllerUtility alertControllerWithTitle:@"Login Success" message:[NSString stringWithFormat:@"Login success with granted permission: %@", [[result.grantedPermissions allObjects] componentsJoinedByString:@" "]]];
            [_customLoginButton setTitle:@"Facebook logout" forState:UIControlStateNormal];
            DLog(@"%@", [[result.grantedPermissions allObjects] componentsJoinedByString:@" "]);
            DLog(@"%@", [result token].tokenString);
            DLog(@"%@", result);
        }
        [self presentViewController:alertController animated:YES completion:nil];
    };
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    // user never login or already log out so access token is nil
    if (![FBSDKAccessToken currentAccessToken]) {
        [loginManager logInWithReadPermissions:@[@"public_profile", @"user_friends"]
                            fromViewController:self
                                       handler:loginHandler];
    } else {
        // user login successfully and access token is not nil
        [loginManager logOut];
        UIAlertController *alertController = [AlertControllerUtility alertControllerWithTitle:@"Logout"
                                                                                      message:@"Logout"];
        [_customLoginButton setTitle:@"Facebook login" forState:UIControlStateNormal];
        // This line will cause error:Unbalanced calls to begin/end appearance transitions for <UINavigationController: 0x145023600>
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLoginButtonLayoutConstraint];
    // check current login status
    if ([FBSDKAccessToken currentAccessToken]) {
//        MainViewController *mainViewController = [[MainViewController alloc] init];
//        [self.navigationController presentViewController:mainViewController animated:NO completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - FBSDKLoginButtonDelegate method

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    UIAlertController *alertController;
    if (error) {
        alertController = [AlertControllerUtility alertControllerWithTitle:@"Login Fail" message:[NSString stringWithFormat:@"Login failed with error:%@", error]];
    } else if (!result || result.isCancelled) {
        alertController = [AlertControllerUtility alertControllerWithTitle:@"Login Cancelled" message:[NSString stringWithFormat:@"User cancelled login"]];
    } else {
        alertController = [AlertControllerUtility alertControllerWithTitle:@"Login Success" message:[NSString stringWithFormat:@"Login success with granted permission: %@", [[result.grantedPermissions allObjects] componentsJoinedByString:@" "]]];
        DLog(@"%@", [[result.grantedPermissions allObjects] componentsJoinedByString:@" "]);
        DLog(@"%@", [result token].tokenString);
    }

    [self presentViewController:alertController animated:YES completion:^{
    }];
    
//    MainViewController *mainViewController = [[MainViewController alloc] init];
//    [self.navigationController presentViewController:mainViewController animated:NO completion:nil];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    UIAlertController *alertController = [AlertControllerUtility alertControllerWithTitle:@"Login out" message:[NSString stringWithFormat:@"Log out success"]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - setLoginButtonLayoutConstraint

- (void)setLoginButtonLayoutConstraint {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.fbLoginButton];
    [self.view addSubview:self.customLoginButton];
    
    // fbLoginButton
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.fbLoginButton
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:50.f]];
    
    [self.fbLoginButton addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:40.f]];
    
    // customLoginButton
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.customLoginButton
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.customLoginButton
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fbLoginButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.customLoginButton
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:50.f]];
    
    [self.customLoginButton addConstraint:[NSLayoutConstraint constraintWithItem:self.customLoginButton
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:40.f]];
}

@end
