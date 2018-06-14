//
//  VerticalCollectionView.h
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/9/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalCollectionView : UICollectionView

@property(copy, nonatomic) NSArray *proDataSource;
@property(assign, nonatomic) NSInteger numberOfItems;
@property(assign, nonatomic) NSInteger sections;

@end
