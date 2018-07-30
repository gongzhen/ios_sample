//
//  ViewController.m
//  UIImageDrawText
//
//  Created by gongzhen on 2/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Drawtext.h"
#import "NSMutableAttributedString+Attributes.h"
#import "UIView+AutoLayoutHelper.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) UIButton *submitButton;

@end

@implementation ViewController

#pragma mark - submitButton

- (UIButton *)submitButton {
    if (_submitButton == nil) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        UIImage *image = [UIImage imageNamed:@"button_black"];
        [_submitButton setBackgroundImage:image forState:UIControlStateNormal];
        [_submitButton setTitle:@"HAS NEW QUOTE" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.tag = 0;
    }
    return _submitButton;
}

- (void)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        {
            UIImage *image = [self swatchWithColor:[UIColor blueColor] side:40.f];
            UIImageView *drawIamgeView = [[UIImageView alloc] initWithImage:image];
            [drawIamgeView setCenter:self.view.center];
            [self.view addSubview:drawIamgeView];
        }
            break;
        default:
            break;
    }
}

- (UIImage *)swatchWithColor:(UIColor *)color side:(CGFloat)side {
    // Create image context(using the main screen scale)
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), NO, 0.0);
    // 开始绘制
    [color setFill];
    UIRectFill(CGRectMake(0, 0, side, side));
    
    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.submitButton];
    [self.submitButton addHeightConstraintWithRelation:NSLayoutRelationEqual constant:48.f];
    [self.submitButton addBottomConstraintToView:self.submitButton.superview relation:NSLayoutRelationEqual constant:-30.f];
    [self.submitButton addLeftConstraintToView:self.submitButton.superview relation:NSLayoutRelationEqual constant:10.f];
    [self.submitButton addRightConstraintToView:self.submitButton.superview relation:NSLayoutRelationEqual constant:-10.f];
//    UIImage *bgImage = [UIImage imageNamed:@"background_main"];
//    CGPoint point = CGPointMake(bgImage.size.width / 2.f, bgImage.size.height / 2.f);
//    UIFont *font = [UIFont fontWithName:@"Courier" size:20.f];
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor darkGrayColor];
//    shadow.shadowOffset = CGSizeMake(1.f, 1.5f);
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"TEXT"];
//    NSRange range = NSMakeRange(0, [attString length]);
//    [attString setAttributedStringWithFont:font withColor:[UIColor redColor] withShadow:shadow withRange:range];
//    UIImage *bgImageWithText = [bgImage drawText:attString inImage:bgImage atPoint:point font:font textColor:[UIColor redColor]];
//    _backgroundImageView.image = bgImageWithText;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *bgImage = [UIImage imageNamed:@"background_main"];
    CGPoint point = CGPointMake(bgImage.size.width / 3.f, bgImage.size.height / 2.f);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(1.f, 1.5f);
    UIFont *font = [UIFont fontWithName:@"Courier" size:18.f];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"TEXT"];
    NSRange range = NSMakeRange(0, [attString length]);
    [attString setAttributedStringWithFont:font withColor:[UIColor blueColor] withShadow:shadow withRange:range];
    UIImage *bgImageWithText = [bgImage drawText:attString inImage:bgImage atPoint:point font:font textColor:[UIColor blueColor] shadow:shadow];
    _backgroundImageView.image = bgImageWithText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
