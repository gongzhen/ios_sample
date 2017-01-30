//
//  ManagePageViewController.m
//  PhotoScrollObjC
//
//  Created by gongzhen on 10/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ManagePageViewController.h"
#import "PhotoCommentViewController.h"

@interface ManagePageViewController(){
    NSMutableArray* _controllers;
}
@property(strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation ManagePageViewController

//-(UIPageViewController *)pageViewController {
//    if (_pageViewController == nil){
//        UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: nil];
//        self.pageViewController.delegate = self;
//        self.pageViewController.dataSource = self;
//        [[_pageViewController view] setFrame:self.view.bounds];
//        _pageViewController = pageViewController;
//    }
//    return _pageViewController;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupPhotos];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [[self.pageViewController view] setFrame:self.view.bounds];
    if (_currentIndex == NSNotFound) {
        _currentIndex = 0;
    }
    DLog(@"currentIndex: %ld", _currentIndex);
    PhotoCommentViewController *pageCommentViewController = [self viewPhotoCommentController: _currentIndex];
    if (pageCommentViewController == nil) {
        return;
    }
    
    _controllers = [NSMutableArray arrayWithObject: pageCommentViewController];
    [self.pageViewController setViewControllers:_controllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

-(PhotoCommentViewController *)viewPhotoCommentController:(NSInteger)index {
    PhotoCommentViewController *page = [[PhotoCommentViewController alloc] init];
    if (page == nil) {
        return nil;
    }
    page.photoName = _photos[index];
    page.photoIndex = index;
    return page;
}

#pragma mark initializer photos
-(void)setupPhotos {
    NSMutableArray *mutablePhotos = [NSMutableArray array];
    for (int i = 0; i <=5; i++) {
        [mutablePhotos addObject: [NSString stringWithFormat: @"photo%d", i]];
    }
    _photos = [NSArray arrayWithArray: mutablePhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPageViewControllerDataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    PhotoCommentViewController *photoCommentViewController = (PhotoCommentViewController *)viewController;
    if (photoCommentViewController == nil) {
        return nil;
    }
    
    NSInteger index = photoCommentViewController.photoIndex;
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    
    index = index - 1;
    return [self viewPhotoCommentController: index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    PhotoCommentViewController *photoCommentViewController = (PhotoCommentViewController *)viewController;
    if (photoCommentViewController == nil) {
        return nil;
    }
    NSInteger index = photoCommentViewController.photoIndex;
    if (index == NSNotFound) {
        return nil;
    }
    index = index + 1;
    if (index == _photos.count) {
        return nil;
    }
    return [self viewPhotoCommentController:index];
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return _photos.count;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return _currentIndex;
}

@end
