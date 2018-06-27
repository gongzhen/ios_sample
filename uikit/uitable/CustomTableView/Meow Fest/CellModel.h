//
//  CellModel.h
//  Meow Fest
//
//  Created by Zhen Gong on 6/21/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellModel : NSObject

@property(strong, nonatomic) UIImage *image;
@property(copy, nonatomic) NSString *imageURL;
@property(copy, nonatomic) NSString *desc;
@property(copy, nonatomic) NSString *timestamp;
@property(copy, nonatomic) NSString *title;

- (instancetype)initWithDesc:(NSString *)desc title:(NSString *)title ts:(NSString *)ts url:(NSString *)url;

@end
