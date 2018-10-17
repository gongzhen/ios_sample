//
//  PinterestLayout.h
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PinterestLayoutDelegate<NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PinterestLayout : UICollectionViewLayout

@property(weak, nonatomic, nullable) id<PinterestLayoutDelegate> delegate;

@end
