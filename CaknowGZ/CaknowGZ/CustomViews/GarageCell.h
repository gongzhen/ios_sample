//
//  GarageCell.h
//  CaknowGZ
//
//  Created by gongzhen on 3/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetConsumerVehiclesVehiclesEntity.h"

@interface GarageCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *brandImageView;
@property (strong, nonatomic) UILabel *modelLabel;
@property (strong, nonatomic) UILabel *quoteCountLabel;
@property (strong, nonatomic) UIView *brandBackgroundView;

@property (strong, nonatomic) GetConsumerVehiclesVehiclesEntity *vehicleEntity;

@end
