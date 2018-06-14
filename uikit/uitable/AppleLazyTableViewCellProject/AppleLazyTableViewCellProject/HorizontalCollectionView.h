//
//  HorizontalCollectionView.h
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/5/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalCollectionViewDelegate <NSObject>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HorizontalCollectionView : UICollectionView

@property(copy, nonatomic) NSArray *proDataSource;
@property(assign, nonatomic) NSInteger numberOfItems;
@property(assign, nonatomic) NSInteger sections;
@property(weak, nonatomic) id<HorizontalCollectionViewDelegate> subDelegate;

@end
