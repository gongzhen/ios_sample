//
//  Artist.h
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/4/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Work.h"

@interface Artist : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *works;


- (instancetype)initWithName:(NSString *)name
                         bio:(NSString *)bio
                       image:(UIImage *)image
                       works:(NSMutableArray *)works;

+ (NSMutableArray *)artistsFromBundle;
@end
