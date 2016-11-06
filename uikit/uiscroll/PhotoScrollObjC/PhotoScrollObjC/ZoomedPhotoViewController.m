//
//  ZoomedPhotoViewController.m
//  PhotoScrollObjC
//
//  Created by gongzhen on 11/3/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ZoomedPhotoViewController.h"

@interface ZoomedPhotoViewController() <UIScrollViewDelegate> {
    @private
}

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSLayoutConstraint *imageViewBottomConstraint;
@property(nonatomic, strong) NSLayoutConstraint *imageViewLeadingConstraint;
@property(nonatomic, strong) NSLayoutConstraint *imageViewTopConstraint;
@property(nonatomic, strong) NSLayoutConstraint *imageViewTrailingConstraint;

@end

@implementation ZoomedPhotoViewController

#pragma mark lazy loading imageview.

-(UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor greenColor];
        _imageView = imageView;
    }
    return _imageView;
}

#pragma mark lazy loading scrollview
-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.showsHorizontalScrollIndicator = YES;
        scrollView.scrollEnabled = YES;
        scrollView.bounces = YES;
        scrollView.bouncesZoom = YES;
        scrollView.delaysContentTouches =YES;
        scrollView.canCancelContentTouches = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.clipsToBounds = YES;
        scrollView.autoresizesSubviews = YES;
        scrollView.contentSize = self.view.bounds.size;
        scrollView.backgroundColor = [UIColor blueColor];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    
    [self setupScrollView];
    self.scrollView.delegate = self;
    if (_photoName) {
        self.imageView.image = [UIImage imageNamed: _photoName];
    }
}

#pragma mark viewdidlayoutsubviews
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateMinZoomScaleForSize: self.view.bounds.size];
}

#pragma mark updateMinZoomScaleForSize
-(void)updateMinZoomScaleForSize:(CGSize)size{
    CGFloat widthScale = size.width / self.imageView.bounds.size.width;
    CGFloat heightScale = size.height / self.imageView.bounds.size.height;
    CGFloat minScale = MIN(widthScale, heightScale);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
}

#pragma mark updateConstraintsForSize
-(void)updateConstraintsForSize:(CGSize)size {
    
    CGFloat yOffset = MAX(0, (size.height - self.imageView.frame.size.height) / 2);
    DLog(@"size: %@", NSStringFromCGSize(size));
    DLog(@"yOffset: %f", yOffset);
    DLog(@"toplayoutguide: %@", self.topLayoutGuide);
    self.imageViewTopConstraint.constant = yOffset;
    self.imageViewBottomConstraint.constant = yOffset;
    
    CGFloat xOffset = MAX(0, (size.width - self.imageView.frame.size.width) / 2);
    self.imageViewLeadingConstraint.constant = xOffset;
    self.imageViewTrailingConstraint.constant = xOffset;
    [self.view layoutIfNeeded];
}

#pragma mark setupScrollView
-(void)setupScrollView {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //scrollView topLayoutGuide
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute: NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
    
    //scrollView bottomLayoutGuide
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier:1.f constant:0.f]];
    // scrollView leading
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute: NSLayoutAttributeLeading multiplier:1.f constant:0.f]];
    // scrollView trailing
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute: NSLayoutAttributeTrailing multiplier:1.f constant:0.f]];

    //imageView top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.imageView attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute: NSLayoutAttributeTop multiplier:1.f constant:self.view.frame.size.height / 3]];
    
    self.imageViewTopConstraint = [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute: NSLayoutAttributeTop multiplier:1.f constant:self.view.frame.size.height / 3];
    
    //imageView bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute: NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
    self.imageViewBottomConstraint = [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute: NSLayoutAttributeBottom multiplier:1.f constant: 0.f];
    
    // imageView leading
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute: NSLayoutAttributeLeading multiplier:1.f constant:0.f]];
    self.imageViewLeadingConstraint = [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute: NSLayoutAttributeLeading multiplier:1.f constant:0.f];
    
    // imageView trailing
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute: NSLayoutAttributeTrailing multiplier:1.f constant:0.f]];
    self.imageViewTrailingConstraint = [NSLayoutConstraint constraintWithItem: self.scrollView attribute: NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute: NSLayoutAttributeTrailing multiplier:1.f constant:0.f];
    
    // imageView width
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.imageView attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.f constant:1024.f]];
    
    // imageView height
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem: self.imageView attribute: NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.f constant:768.f]];
}

#pragma mark UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateConstraintsForSize:self.view.bounds.size];
}

@end
