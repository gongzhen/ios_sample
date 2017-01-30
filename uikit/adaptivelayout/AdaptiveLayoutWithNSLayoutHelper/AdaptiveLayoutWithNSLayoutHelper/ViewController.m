//
//  ViewController.m
//  AdaptiveLayoutWithNSLayoutHelper
//
//  Created by gongzhen on 12/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *textContainer;
@property (nonatomic, strong) UILabel *cupertinoLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation ViewController

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _imageView.image = [UIImage imageNamed:@"background_launch_screen"];        
    }
    return _imageView;
}

- (UIView *)textContainer {
    if (_textContainer == nil) {
        _textContainer = [[UIView alloc] init];
        [_textContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _textContainer;
}

- (UILabel *)cupertinoLabel {
    if (_cupertinoLabel == nil) {
        _cupertinoLabel = [[UILabel alloc] init];
        [_cupertinoLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _cupertinoLabel;
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _numberLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.imageView];
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
