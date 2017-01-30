//
//  ViewController.m
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "ThirdPartyLoginManager.h"
#import "ConfirmViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController () <FBSDKLoginTooltipViewDelegate, FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *fbuserProfileView;
@property (weak, nonatomic) IBOutlet UILabel *fbuserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fbuserLoginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.fbuserLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        DLog(@"currentAccessToken %@", [FBSDKAccessToken currentAccessToken].tokenString);
        // _fbuserLoginButton.hidden = YES;
    } else {
        // _fbuserLoginButton.hidden = NO;
    }
    
    // _fbuserLoginButton.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButtonClicked:(id)sender {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (token) {
        // auto login
        [FBSDKAccessToken setCurrentAccessToken:token];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture, email"}];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            DLog(@"access connection: %@", connection.description);
            ConfirmViewController *confirmViewController = [[ConfirmViewController alloc] init];
            [self.navigationController pushViewController:confirmViewController animated:YES];
        }];
        
    } else {
        // not login
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_about_me"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        DLog(@"%@", result);
                                        DLog(@"access token: %@", result.token.tokenString);
                                        ConfirmViewController *confirmViewController = [[ConfirmViewController alloc] init];
                                        
                                        [self.navigationController pushViewController:confirmViewController animated:YES];
                                    }
                                }];
    }
}

#pragma mark - Authentication

- (void)fbhandleAuthenticationResponse:(BOOL)succes withError:(NSError *)error {
    if (succes == YES) {
        
    } else {
        
    }
}

#pragma mark - FBLoginView Delegate method implementation

- (void)loginTooltipViewWillAppear:(FBSDKLoginTooltipView *)view {
    
}



#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        DLog(@"%@", error);
    } else if (!result || result.isCancelled) {
        DLog(@"Cancelled.");
    } else {
        NSString *facebookToken = result.token.tokenString;
        DLog(@"facebookToken: %@", facebookToken);
        [[ThirdPartyLoginManager sharedInstance] authenticateByFacebookToken:facebookToken completionHandler:^(BOOL success, NSError *error) {
            
        }];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {

}



@end
