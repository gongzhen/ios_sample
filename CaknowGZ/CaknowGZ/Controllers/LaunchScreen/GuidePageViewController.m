//
//  GuidePageViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/24/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GuidePageViewController.h"

@interface GuidePageViewController ()

@end

@implementation GuidePageViewController

#pragma mark - properties

- (UILabel *)serviceLabel {
    if (_serviceLabel == nil) {
        _serviceLabel = [[UILabel alloc] init];
        [_serviceLabel setTextAlignment:NSTextAlignmentCenter];
        [_serviceLabel setTextColor:[UIColor whiteColor]];
    }
    return _serviceLabel;
}

- (UITextView *)serviceTextView {
    if (_serviceTextView == nil) {
        _serviceTextView = [[UITextView alloc] init];
        _serviceTextView.backgroundColor = [UIColor clearColor];
        [_serviceTextView setTextColor:[UIColor whiteColor]];
    }
    return _serviceTextView;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        [_backgroundImageView setOpaque:YES];
    }
    return _backgroundImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setOpaque:YES];
//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.extendedLayoutIncludesOpaqueBars=YES;
//    self.automaticallyAdjustsScrollViewInsets=YES;
    
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView addSubview:self.serviceLabel];
    [self.backgroundImageView addSubview:self.serviceTextView];
    
    __weak typeof(self) weakSelf = self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0.f);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
    }];
    
    [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backgroundImageView.mas_left).with.offset(20.f);
        make.right.equalTo(weakSelf.backgroundImageView.mas_right).with.offset(-20.f);
        make.height.mas_equalTo(20.f);
        make.centerX.equalTo(weakSelf.backgroundImageView.mas_centerX).with.offset(0.f);
        make.centerY.equalTo(weakSelf.backgroundImageView.mas_centerY).with.offset(self.view.bounds.size.height * 1 / 4);
    }];
    
    [self.serviceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.self.serviceLabel.mas_bottom).with.offset(0.f);
        make.left.equalTo(weakSelf.backgroundImageView.mas_left).with.offset(10.f);
        make.bottom.equalTo(weakSelf.backgroundImageView.mas_bottom).with.offset(0.f);
        make.right.equalTo(weakSelf.backgroundImageView.mas_right).with.offset(-10.f);
        
    }];        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
