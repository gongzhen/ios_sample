//
//  GuideViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 1/22/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GuideViewController.h"
#import "GuidePageViewController.h"
#import "GuidePageGetStartViewController.h"
#import "SignMainViewController.h"


@interface GuideViewController () {
    NSMutableArray *_pages;
    NSArray *_backgroundImages;
    NSArray *_labelTexts;
    NSArray *_textViewContents;
}
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false; // Set this property to false if your view controller implementation manages its own scroll view inset adjustments. 
    [self setupResource];
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    [[_pageViewController view] setFrame:self.view.bounds];
    
    if (_currentIndex == NSNotFound) {
        _currentIndex = 0;
    }
    
    UIViewController *guidePageViewController = [self generatePageViewControllers:_currentIndex];

    if (guidePageViewController == nil) {
        return;
    }
    
    _pages = [NSMutableArray arrayWithObject:guidePageViewController];
    [_pageViewController setViewControllers:_pages
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL finished) {
                                 }];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (viewController == nil) {
        return nil;
    }
    
    NSInteger index;
    
    if ([viewController isKindOfClass:[GuidePageViewController class]]) {
        GuidePageViewController *_viewController = (GuidePageViewController *)viewController;
        index = _viewController.pageIndex;
    } else if ([viewController isKindOfClass:[GuidePageGetStartViewController class]]) {
        GuidePageGetStartViewController *_viewController = (GuidePageGetStartViewController *)viewController;
        index = _viewController.pageIndex;
    }
    
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    
    index = index - 1;
    return [self generatePageViewControllers:index];
}

#pragma mark - PageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (viewController == nil) {
        return nil;
    }
    
    NSInteger index;
    if ([viewController isKindOfClass:[GuidePageViewController class]]) {
        GuidePageViewController *_viewController = (GuidePageViewController *)viewController;
        index = _viewController.pageIndex;
    } else if ([viewController isKindOfClass:[GuidePageGetStartViewController class]]) {
        GuidePageGetStartViewController *_viewController = (GuidePageGetStartViewController *)viewController;
        index = _viewController.pageIndex;
    }

    if (index == NSNotFound) {
        return nil;
    }
    index = index + 1;
    
    if (index == _backgroundImages.count) {
        return nil;
    }
    return [self generatePageViewControllers:index];
}

#pragma mark - private method

- (UIViewController *)generatePageViewControllers:(NSInteger)index {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_backgroundImages objectAtIndex:index]]];
    if (index + 1 == _backgroundImages.count) {
        GuidePageGetStartViewController *getStartPageViewController = [[GuidePageGetStartViewController alloc] init];
        if (getStartPageViewController == nil) {
            return nil;
        }
        
        [getStartPageViewController.headerLabel setText:@"AUTOMOTIVE SERVICE AT YOUR FINGERTIPS"];
        [getStartPageViewController setBackgroundImageView:backgroundImageView];
        [getStartPageViewController.getStartButton setTitle:@"Get Start" forState:UIControlStateNormal];
        [getStartPageViewController.emergencyCallButton setTitle:@"Emergency" forState:UIControlStateNormal];;
        getStartPageViewController.pageIndex = index;
        return getStartPageViewController;
    } else {
        GuidePageViewController *page = [[GuidePageViewController alloc] init];
        if (page == nil) {
            return nil;
        }
        [page setBackgroundImageView: backgroundImageView];
        [page.serviceLabel setText:[_labelTexts objectAtIndex:index]];
        [page.serviceTextView setText:[_textViewContents objectAtIndex:index]];
        page.pageIndex = index;
        return page;
    }
    return nil;
}

- (void)setupResource {
    _backgroundImages = @[kBackgroundguidepage00, kBackgroundguidepage01, kBackgroundguidepage02, kBackgroundguidepage03];
    _labelTexts = @[@"Car Service Needs?", @"We Help You Save!", @"Rewards Programme"];
    _textViewContents = @[
                          @"With CAKNOW you can find the most reliable car repair locations for all your automotive needs. ",
                          @"Save money and time through the convenience of our reliable network. You can compare prices, ratings and distances between available shops near you.",
                          @"Earning CAKNOW points is easy. Redeem points towards future repairs and gift cards!"
                          ];
}

@end
