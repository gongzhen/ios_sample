//
//  ProModel.h
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 5/27/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProModel : NSObject

@property(strong, nonatomic) UIImage *avatarImage;
@property(copy, nonatomic) NSString *avatarURL;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *distance;
@property(copy, nonatomic) NSString *availability;
@property(copy, nonatomic) NSString *rating;
@property(copy, nonatomic) NSString *pricing;
@property(copy, nonatomic) NSString *dollars;

@end
