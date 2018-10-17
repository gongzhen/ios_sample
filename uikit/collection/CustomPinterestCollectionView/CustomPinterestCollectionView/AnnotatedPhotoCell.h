//
//  AnnotatedPhotoCell.h
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface AnnotatedPhotoCell : UICollectionViewCell

- (void)configure:(Photo *)photo;

@end
