//
//  GuidePageGetStartViewController.h
//  CaknowGZ
//
//  Created by gongzhen on 1/26/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuidePageViewController.h"

@interface GuidePageGetStartViewController : UIViewController

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIButton *getStartButton;
@property (strong, nonatomic) UIButton *emergencyCallButton;
@property (assign, nonatomic) NSInteger pageIndex;

@end
