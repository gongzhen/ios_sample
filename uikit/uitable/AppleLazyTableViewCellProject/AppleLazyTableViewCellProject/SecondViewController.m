//
//  SecondViewController.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 5/28/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "SecondViewController.h"
#import "Webservice.h"
#import "ProListViewModel.h"
#import "ProServicesTableViewCell.h"
#import "ProAvatarDownloader.h"
#import "ProModel.h"
#import "FPSLabel.h"
#import "Constants.h"
#import "UIView+Add.h"

@interface SecondViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField* searchField;

@end

@implementation SecondViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    CGFloat width = self.view.frame.size.width - 40;
    CGFloat yOffset = self.view.frame.size.height / 3;
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(20, yOffset, width, 40)];
    self.searchField.delegate = self;
    self.searchField.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.searchField];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    DLog(@"%@", string);
//        NSString *prefix = @"Other:";
//        _referralSource = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        _referralSource = [NSString stringWithFormat:@"%@%@", prefix, _referralSource];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

@end
