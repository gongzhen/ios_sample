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
#import "ImageResourceConstants.h"

static NSString * const kAccessToken = @"accessToken";

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
    // [[CaknowClient sharedInstance] removeAccessToken];
    [self setupLayoutConstraint];
    
    
    
    NSString *accessToken = [[CaknowClient sharedInstance] getAccessToken:kAccessToken];DLog(@"%@", accessToken);
    if (accessToken == nil || accessToken.length == 0) {
        // go to login view
        [self redirectLoginView];
    } else {
        // go to garage view controller. refresh access token.
        NSDictionary *parameters = @{@"token": accessToken};
        [[HttpRequestManager sharedInstance] create:@"consumer/exchangeToken"
                                         parameters:parameters
                                            success:^(id resultObj) {
                                                DLog(@"%@", resultObj);
                                                if ([resultObj objectForKey:@"token"]) {
                                                    [[CaknowClient sharedInstance] saveAccessToken:[resultObj objectForKey:@"token"] service:kAccessToken];
                                                    [[HttpRequestManager sharedInstance] setAccessToken: [resultObj objectForKey:@"token"]];
                                                }
                                                if ([resultObj objectForKey:@"refreshToken"]) {
                                                    [[CaknowClient sharedInstance] saveAccessToken:[resultObj objectForKey:@"refreshToken"] service:kAccessToken];
                                                }
                                                
                                                GarageViewController *garageViewController = [[GarageViewController alloc] init];
                                                if (!garageViewController) {
                                                    return;
                                                }
                                                
                                                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:garageViewController];
                                                [self presentViewController:navigationController animated:YES completion:nil];
                                 
                                         } failure:^(NSError *error) {
                                             [self redirectLoginView];
                                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)redirectLoginView {
    // SignMainViewController *signMainViewController = [[SignMainViewController alloc] init];
    GuideViewController *signMainViewController = [[GuideViewController alloc] init];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:signMainViewController animated:YES];
}

#pragma mark - ui layout constraint

- (void)setupLayoutConstraint {
    [self.view addSubview:self.backgroundImageView];
    __weak typeof(self) weakSelf = self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
    }];
}

@end
