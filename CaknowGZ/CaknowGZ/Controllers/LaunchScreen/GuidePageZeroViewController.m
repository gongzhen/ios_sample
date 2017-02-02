//
//  GuidePageZeroViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/29/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GuidePageZeroViewController.h"

@interface GuidePageZeroViewController ()

@property (strong, nonatomic) UILabel *serviceLabel;
@property (strong, nonatomic) UITextView *serviceTextView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (assign, nonatomic) NSInteger pageIndex;

@end

@implementation GuidePageZeroViewController

#pragma mark - properties

- (UILabel *)serviceLabel {
    if (_serviceLabel == nil) {
        _serviceLabel = [[UILabel alloc] init];
        [_serviceLabel setTextAlignment:NSTextAlignmentCenter];
        [_serviceLabel setTextColor:[UIColor whiteColor]];
        [_serviceLabel setText:@"Car Service Needs?"];
    }
    return _serviceLabel;
}

- (UITextView *)serviceTextView {
    if (_serviceTextView == nil) {
        _serviceTextView = [[UITextView alloc] init];
        _serviceTextView.backgroundColor = [UIColor clearColor];
        [_serviceTextView setTextColor:[UIColor whiteColor]];
        [_serviceTextView setText:@"With CAKNOW you can find the most reliable car repair locations for all your automotive needs. "];
    }
    return _serviceTextView;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [_backgroundImageView setOpaque:YES];
        _backgroundImageView.image = [UIImage imageNamed:kBackgroundguidepage00];
        [_backgroundImageView setFrame:[[UIScreen mainScreen]bounds]];
    }
    return _backgroundImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self.view setOpaque:YES];
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.serviceLabel];
    [self.view addSubview:self.serviceTextView];
    
    __weak typeof(self) weakSelf = self;
//    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
//        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
//        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
//        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
//    }];
    
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20.f);
        make.height.mas_equalTo(20.f);
        make.centerX.equalTo(weakSelf.view.mas_centerX).with.offset(0.f);
        make.centerY.equalTo(weakSelf.view.mas_centerY).with.offset(self.view.bounds.size.height * 1 / 4);
    }];
    
    [self.serviceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.self.serviceLabel.mas_bottom).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(10.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.f);
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
