//
//  PhotoCell.m
//  PhotoScrollObjC
//
//  Created by gongzhen on 10/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell()

@end

@implementation PhotoCell

#pragma mark lazy loading.

-(UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.bounds];
        _imageView = imageView;
    }
    return _imageView;
}

#pragma mark initializer
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.contentView];
        [self.contentView addSubview: self.imageView];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

-(void)prepareForReuse {
    [super prepareForReuse];
//    [self.imageView removeFromSuperview];
//    self.imageView = nil;
    // self.titleLabel.text = @"";
}

@end
