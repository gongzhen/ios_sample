//
//  ViewController.m
//  ScrollViewDemo_ObjC
//
//  Created by gongzhen on 11/6/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"

// UIScrollView tutorial
// http://www.appcoda.com/uiscrollview-introduction/
@interface ViewController ()

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: [UIScreen mainScreen].bounds];
        scrollView.contentSize = self.imageView.bounds.size;
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        // UIScrollView has a contentOffset property that you can change which will have the same effect as
        // changing the bounds origin. Paste the following statement after the line that sets the scroll view’s
        // autoresizingMask.
        scrollView.contentOffset = CGPointMake(1000, 450);
        _scrollView = scrollView;
    }
    return _scrollView;
}

-(UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"image.png"]];
        _imageView = imageView;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    
    [self setZoomScale];
    [self setupGestureRecognizer];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setZoomScale];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize imageViewSize = self.imageView.frame.size;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    float verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    float horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

// scroll View must implement this method to revoke setZoomScale
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark private method
-(void)setZoomScale {
    // compare the ratio for scrollView height / imageView height and scrollView width / imageView width
    // find the minimum zoom scale and set it as the minmumZoomScale
    CGSize imageViewSize = self.imageView.bounds.size;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    float widthScale = scrollViewSize.width / imageViewSize.width;
    NSLog(@"widthScale: %f / %f = %f", scrollViewSize.width, imageViewSize.width, widthScale);
    float heightScale = scrollViewSize.height / imageViewSize.height;
    NSLog(@"heightScale: %f / %f = %f", scrollViewSize.height, imageViewSize.height, heightScale);
    self.scrollView.minimumZoomScale = MIN(widthScale, heightScale);
    self.scrollView.zoomScale = 1.0;
}

#pragma mark setupGestureRecognizer

-(void)setupGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
}

#pragma mark handle doubleTap
-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"zoomScale:%f", self.scrollView.zoomScale);
    NSLog(@"minimumZoomScale:%f", self.scrollView.minimumZoomScale);
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
