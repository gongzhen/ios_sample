//
//  AnnotatedPhotoCell.m
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "AnnotatedPhotoCell.h"
#import "Photos.h"

@interface AnnotatedPhotoCell()

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *captionLabel;
@property (strong, nonatomic) UILabel *commentLabel;

@end

@implementation AnnotatedPhotoCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.layer.cornerRadius = 6.f;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)captionLabel {
    if (!_captionLabel) {
        _captionLabel = [[UILabel alloc] init];
    }
    return _captionLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
    }
    return _commentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.imageView];
//        [self.containerView addSubview:self.captionLabel];
//        [self.containerView addSubview:self.commentLabel];
//        self.captionLabel.backgroundColor = UIColor.yellowColor;
//        self.commentLabel.backgroundColor = UIColor.greenColor;
        [self installConstraints];
    }
    return self;
}

- (void)installConstraints {
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.captionLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:0.f].active = YES;
    [self.containerView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:0.f].active = YES;
    [self.containerView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:0.f].active = YES;
    [self.containerView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:0.f].active = YES;
    
    [self.imageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:0.f].active = YES;
    [self.imageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:0.f].active = YES;
    [self.imageView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:0.f].active = YES;
    [self.imageView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:0.f].active = YES;
//    [self.captionLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:10.f].active = YES;
//    [self.captionLabel.leadingAnchor constraintEqualToAnchor:self.imageView.leadingAnchor constant:4.f].active = YES;
//    [self.captionLabel.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor constant:-4.f].active = YES;
//
//    [self.commentLabel.topAnchor constraintEqualToAnchor:self.captionLabel.bottomAnchor constant:2.f].active = YES;
//    [self.commentLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-4.f].active = YES;
//    [self.commentLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:4.f].active = YES;
//    [self.commentLabel.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor constant:10.f].active = YES;
}

- (void)configure:(Photo *)photo {
    self.imageView.image = photo.image;
    self.captionLabel.text = [photo.caption copy];
    self.commentLabel.text = [photo.comment copy];
}
@end
