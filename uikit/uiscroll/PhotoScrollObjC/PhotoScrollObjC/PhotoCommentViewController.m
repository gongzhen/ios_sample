//
//  PhotoCommentViewController.m
//  PhotoScrollObjC
//
//  Created by gongzhen on 10/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "PhotoCommentViewController.h"
#import "ZoomedPhotoViewController.h"

@interface PhotoCommentViewController ()

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UITextField *nameTextField;

@end

@implementation PhotoCommentViewController

#pragma mark lazing loading scroll view
-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.showsHorizontalScrollIndicator = YES;
        scrollView.scrollEnabled = YES;
        scrollView.bounces = YES;
        scrollView.bouncesZoom = YES;
        scrollView.delaysContentTouches = YES;
        scrollView.canCancelContentTouches = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.multipleTouchEnabled = YES;
        scrollView.opaque = YES;
        scrollView.clearsContextBeforeDrawing = YES;
        scrollView.clipsToBounds = YES;
        scrollView.autoresizesSubviews = YES;
        scrollView.backgroundColor = [UIColor whiteColor];
        
        scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _scrollView = scrollView;
    }
    return _scrollView;
}

#pragma mark lazing loading image view

-(UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
    }
    return _imageView;
}

#pragma mark lifecycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup scroll view
    [self setupScrollView];
    
    if (_photoName) {
        self.imageView.image = [UIImage imageNamed: _photoName];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(openZoomingController:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.imageView addGestureRecognizer: tapGestureRecognizer];
    }
}

-(void)openZoomingController:(UITapGestureRecognizer *)tap {
    ZoomedPhotoViewController *zoomedPhotoViewController = [[ZoomedPhotoViewController alloc] init];
    zoomedPhotoViewController.photoName = _photoName;
    [self.navigationController pushViewController: zoomedPhotoViewController animated:YES];
}

-(void)setupScrollView {

//    testing purpose.
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = [UIImage imageNamed: _photoName];
//    imageView.clipsToBounds = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:scrollView];
//    [scrollView addSubview:imageView];
//    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
//    imageView.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:@{ @"scrollView": scrollView }]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics: 0 views:@{ @"scrollView": scrollView }]];
//    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics: 0 views:@{ @"imageView": imageView }]];
//    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics: 0 views:@{ @"imageView": imageView }]];
//    DLog(@"imageView: %@", NSStringFromCGRect(self.imageView.bounds));
//    DLog(@"image: %@", self.imageView.image);
    
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview: self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // scrollview width
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.f constant: self.view.bounds.size.width]];

    //scrollview top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
    //scrollview bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
    //scrollview leading
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute: NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f]];
    //scrollview trailing
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute: NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f]];

    // imageview top
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
    // imageView width
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:self.view.bounds.size.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:300.f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (_photoName) {
        self.imageView.image = [UIImage imageNamed:_photoName];
    }
}

@end
