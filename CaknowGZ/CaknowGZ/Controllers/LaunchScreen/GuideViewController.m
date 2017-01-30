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
    
    _backgroundImages = @[kBackgroundguidepage00, kBackgroundguidepage01, kBackgroundguidepage02, kBackgroundguidepage03];
    [self setupTextContent];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:self.view.bounds];
    
    if (_currentIndex == NSNotFound) {
        _currentIndex = 0;
    }
    UIViewController *guidePageViewController = [self generatePageViewControllers: _currentIndex];
    if (guidePageViewController == Nil) {
        return ;
    }
    _pages = [NSMutableArray arrayWithObject:guidePageViewController];
    [self.pageViewController setViewControllers:_pages
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:^(BOOL finished) {
                                     
                                 }];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - helper method

- (UIViewController *)generatePageViewControllers:(NSInteger)index {

    UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_backgroundImages objectAtIndex:index]]];
    if (index + 1 == _backgroundImages.count) {
        // index == 3
        DLog(@"%ld", (long)index);
        GuidePageGetStartViewController * getStartPage = [[GuidePageGetStartViewController alloc] init];
        if (getStartPage == nil) {
            return nil;
        }
        [getStartPage.headerLabel setText:@"AUTOMOTIVE SERVICE AT YOUR FINGERTIPS"];
        getStartPage.backgroundImageView = backgroudImageView;
        [getStartPage.getStartButton setTitle:@"Get Start" forState:UIControlStateNormal];
        [getStartPage.emergencyCallButton setTitle:@"Emergency" forState:UIControlStateNormal];;
        getStartPage.pageIndex = index;
        return getStartPage;
    } else {
        // index == 0, 1, 2
        DLog(@"%ld", (long)index);
        GuidePageViewController *page = [[GuidePageViewController alloc] init];
        if (page == nil) {
            return nil;
        }        
        page.backgroundImageView = backgroudImageView;
        page.serviceLabel.text = [_labelTexts objectAtIndex:index];
        page.serviceTextView.text = [_textViewContents objectAtIndex:index];
        page.pageIndex = index;
        return page;
    }
    return nil;
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
    DLog(@"%ld", (long)index);
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
    DLog(@"%ld", (long)index);
    if (index == NSNotFound) {
        return nil;
    }
    index = index + 1;
    
    if (index == _backgroundImages.count) {
        return nil;
    }
    return [self generatePageViewControllers:index];
}

#pragma mark - helper method
- (void)setupTextContent {
    _labelTexts = @[@"Car Service Needs?", @"We Help You Save!", @"Rewards Programme"];
    _textViewContents = @[
                          @"With CAKNOW you can find the most reliable car repair locations for all your automotive needs. ",
                          @"Save money and time through the convenience of our reliable network. You can compare prices, ratings and distances between available shops near you.",
                          @"Earning CAKNOW points is easy. Redeem points towards future repairs and gift cards!"
                          ];
}

@end
