//
//  ViewController.m
//  FBSDKObjC_Login
//
//  Created by gongzhen on 12/8/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SUCache.h"
#import <UIKit/UIKit.h>
#import "UIImageView+CreateByUrl.h"
#import "ConfirmViewController.h"

// https://github.com/chenhuaizhe/facebookLoginDemo/blob/master/fabdemo/ViewController.m

@interface ViewController () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *fbuserProfileView;
@property (weak, nonatomic) IBOutlet UILabel *fbuserNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fbuserLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *fbuserEmailLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self isUserLoggedIn]) {
        // _fbuserLoginButton.hidden = YES;
    } else  {
        _fbuserLoginButton.hidden = NO;
    }
}

- (BOOL)isUserLoggedIn {
    DLog(@"currentAccessToken %@", [FBSDKAccessToken currentAccessToken].tokenString);
    return [FBSDKAccessToken currentAccessToken] != nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    
    SUCacheItem *item = [SUCache itemForSlot:0];
    [self labelDisplayWithProfile:item.profile];
}

- (IBAction)loginButtonClicked:(id)sender {
    // NSInteger slot = 0;
    // FBSDKAccessToken *token = [SUCache itemForSlot:slot].token;
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    DLog(@"facebook token:%@", token.tokenString);
    if (token) {
        [self autoLoginWithToken:token];
    }
    else {
        [self newLogin];
    }
}

- (void)autoLoginWithToken:(FBSDKAccessToken *)token {
    // http://blog.libuqing.com/ios/32.html
    [FBSDKAccessToken setCurrentAccessToken:token];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"The user token is no longer valid.");
            NSInteger slot = 0;
            [SUCache deleteItemInSlot:slot];
            [FBSDKAccessToken setCurrentAccessToken:nil];
            [FBSDKProfile setCurrentProfile:nil];
        }
        //做登录完成的操作
        else {
            
        }
    }];
}

- (void)newLogin {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_about_me"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                NSLog(@"facebook login result.grantedPermissions = %@,error = %@",result.grantedPermissions,error);
                                 if (error) {
                                     NSLog(@"Process error");
                                 } else if (result.isCancelled) {
                                     NSLog(@"Cancelled");
                                 } else {
                                     DLog(@"Logged in by token %@", result.token.tokenString);
                                     [[[FBSDKGraphRequest alloc]
                                       initWithGraphPath:@"me" parameters:@{@"fields": @"id,name, first_name, last_name,email, picture.type(large)"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                         if (!error) {
                                             DLog(@"fetched user: %@", result);
                                             _fbuserNameLabel.text = [result objectForKey:@"name"];
                                             _fbuserEmailLabel.text = [result objectForKey:@"email"];
                                             ConfirmViewController *confirmViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmViewController"];
                                             confirmViewController.fbuserNameText = [result objectForKey:@"name"];
                                             confirmViewController.fbuserEmailText = [result objectForKey:@"email"];
                                             NSDictionary *pictureData = [result objectForKey:@"picture"];
                                             if ([pictureData objectForKey:@"data"]) {
                                                 NSDictionary *data = [pictureData objectForKey:@"data"];
                                                 if ([data objectForKey:@"url"]) {
                                                     confirmViewController.imageURLString = [data objectForKey:@"url"];
                                                 }
                                             }
                                             [self.navigationController pushViewController:confirmViewController animated:YES];
                                         } else {
                                             DLog(@"error %@", error);
                                         }
                                     }];
                                 }
                            }];
}




#pragma mark - Notification

- (void)_updateContent:(NSNotification *)notification {
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    [self labelDisplayWithProfile:profile];
}

- (void)_accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    if (!token) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    } else {
        NSInteger slot = 0;
        SUCacheItem *item = [SUCache itemForSlot:slot] ?: [[SUCacheItem alloc] init];
        if (![item.token isEqualToAccessToken:token]) {
            item.token = token;
            [SUCache saveItem:item slot:slot];
        }
    }
}

- (void)labelDisplayWithProfile:(FBSDKProfile *)profile{
    NSInteger slot = 0;
    if (profile) {
        SUCacheItem *cacheItem = [SUCache itemForSlot:slot];
        cacheItem.profile = profile;
        [SUCache saveItem:cacheItem slot:slot];
        self.fbuserNameLabel.text = [NSString stringWithFormat:@"name = %@,userID = %@",cacheItem.profile.name,cacheItem.profile.userID];
        NSURL *imgURL = [profile imageURLForPictureMode:FBSDKProfilePictureModeNormal size:self.fbuserProfileView.frame.size];
        [self.fbuserProfileView setImageByUrl:[NSString stringWithFormat:@"%@",imgURL]];
        
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
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {

}

@end
