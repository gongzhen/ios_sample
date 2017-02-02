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

#import "GuidePageZeroViewController.h"
#import "GuidePageOneViewController.h"
#import "GuidePageTwoViewController.h"
#import "GuidePageThreeViewController.h"

@interface GuideViewController () {
    NSArray *_pages;
}
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false; // Set this property to false if your view controller implementation manages its own scroll view inset adjustments.
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    GuidePageZeroViewController *zeroViewController = [[GuidePageZeroViewController alloc] init];
    GuidePageOneViewController *oneViewController = [[GuidePageOneViewController alloc] init];
    GuidePageTwoViewController *twoViewController = [[GuidePageTwoViewController alloc] init];
    GuidePageThreeViewController *threeViewController = [[GuidePageThreeViewController alloc] init];
    _pages = @[zeroViewController, oneViewController, twoViewController, threeViewController];

    [_pageViewController setViewControllers:@[[_pages objectAtIndex:0]]
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
    NSUInteger index = [_pages indexOfObject:viewController];
    
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    
    return [_pages objectAtIndex:index];
}

#pragma mark - PageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [_pages indexOfObject:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == _pages.count) {
        return nil;
    }
    
    return [_pages objectAtIndex:index];
}


@end
