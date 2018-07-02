//
//  AFCollectionViewCell.h
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/27/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProModel;
@class Webservice;

@interface AFCollectionViewCell : UICollectionViewCell

@property(strong, nonatomic) UIImageView *avatarImage;

- (void)configure:(ProModel *)model webSerivce:(Webservice *)webService completion:(void(^)(UIImage *image))completion;

@end
