//
//  TinderOverlayView.m
//  TinderLike
//
//  Created by zhen gong on 5/25/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "TinderOverlayView.h"

@interface TinderOverlayView()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation TinderOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trollface_300x200"]];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setMode:(TinderOverlayMode)mode
{
    if(_mode != mode) {
        _mode = mode;
        if(_mode == TinderOverlayModeLeft) {
            self.imageView.image = [UIImage imageNamed:@"trollface_300x200"];
        } else {
            self.imageView.image = [UIImage imageNamed:@"thumbs_up_300x300"];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(50, 50, 100, 100);
}

@end
