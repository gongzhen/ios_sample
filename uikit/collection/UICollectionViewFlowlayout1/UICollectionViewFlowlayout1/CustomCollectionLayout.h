//
//  CustomCollectionLayout.h
//  UICollectionViewFlowlayout1
//
//  Created by gongzhen on 4/11/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCollectionLayout;

@protocol CustomCollectionViewLayoutDelegate <NSObject>

@required

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomCollectionLayout *)layout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CustomCollectionLayout : UICollectionViewLayout

@property(weak, nonatomic) id<CustomCollectionViewLayoutDelegate> delegate;

@end
