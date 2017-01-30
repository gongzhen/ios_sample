//
//  ViewController.m
//  FBSDKObjc_CocoPod
//
//  Created by gongzhen on 12/11/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *fbuserProfileView;
@property (weak, nonatomic) IBOutlet UILabel *fbuserNameLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbuserLoginButton;

@property (strong, nonatomic) FBSDKLoginButton *fbLoginButtonProgrammatically;

@end

@implementation ViewController

- (FBSDKLoginButton *)fbLoginButtonProgrammatically {
    if (_fbLoginButtonProgrammatically == nil) {
        _fbLoginButtonProgrammatically = [[FBSDKLoginButton alloc] init];
        CGRect buttonFrame = _fbLoginButtonProgrammatically.frame;
        buttonFrame.size = CGSizeMake(300, 30);
        _fbLoginButtonProgrammatically.frame = buttonFrame;
    }
    return _fbLoginButtonProgrammatically;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view, typically from a nib.
    self.fbuserLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.fbLoginButtonProgrammatically.center = self.view.center;
    [self.view addSubview:self.fbLoginButtonProgrammatically];
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        DLog(@"currentAccessToken %@", [FBSDKAccessToken currentAccessToken].tokenString);
    } else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
