//
//  ManagePageViewController.h
//  PhotoScrollObjC
//
//  Created by gongzhen on 10/30/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagePageViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property(nonatomic, strong) NSArray* photos;
@property(nonatomic, assign) NSInteger currentIndex;
@end
