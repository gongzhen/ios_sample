//
//  GetConsumerVehiclesVehiclesEntity.h
//  CaknowGZ
//
//  Created by gongzhen on 3/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "BaseEntity.h"

@interface GetConsumerVehiclesVehiclesEntity : BaseEntity

@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSString *make;
@property (copy, nonatomic) NSString *model;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *trim;
@property (copy, nonatomic) NSString *mileage;
@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *ut;
@property (copy, nonatomic) NSString *ct;
@property (copy, nonatomic) NSString *active;
@property (assign, nonatomic) NSInteger quoteCount;

@end
