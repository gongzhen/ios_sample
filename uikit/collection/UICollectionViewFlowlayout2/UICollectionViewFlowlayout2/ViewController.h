//
//  ViewController.h
//  UICollectionViewFlowlayout2
//
//  Created by zhen gong on 4/26/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomCollectionLayout.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, CustomCollectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

