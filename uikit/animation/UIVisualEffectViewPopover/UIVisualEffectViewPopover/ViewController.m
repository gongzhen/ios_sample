//
//  ViewController.m
//  UIVisualEffectViewPopover
//
//  Created by zhen gong on 9/16/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UIVisualEffectView* visualEffectView;
@property(nonatomic, strong) UIVisualEffect *effect;
@property(nonatomic, strong) UIView *popoutView;

@property (weak, nonatomic) IBOutlet UIButton *popUpBtn;
@property (strong, nonatomic) UIButton *dismissBtn;

@end

@implementation ViewController

- (UIButton *)dismissBtn {
    if(_dismissBtn == nil) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
        [_dismissBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
        [_dismissBtn setTintColor:[UIColor blackColor]];
        [_dismissBtn addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UIView *)popoutView {
    if(_popoutView == nil) {
        _popoutView = [[UIView alloc] init];
        _popoutView.backgroundColor = [UIColor redColor];
        _popoutView.layer.cornerRadius = 5;
        [_popoutView addSubview:self.dismissBtn];
    }
    return _popoutView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popupViewAction:(id)sender {
    self.popoutView.frame = self.view.bounds;
    NSLog(@"%@", NSStringFromCGRect(self.popoutView.frame));
    [self.view addSubview:self.popoutView];
    self.popoutView.center = self.view.center;
    self.dismissBtn.center = self.popoutView.center;
    self.popoutView.transform = CGAffineTransformMakeScale(1, 1);
    self.popoutView.alpha = 0;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                     self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:_effect];
                     self.popoutView.alpha = 1;
                     self.popoutView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismissBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.popoutView.transform = CGAffineTransformMakeScale(1, 1);
        self.popoutView.alpha = 0;
        self.visualEffectView.effect = nil;
    } completion:^(BOOL finished) {
        [self.popoutView removeFromSuperview];
    }];
}



@end
