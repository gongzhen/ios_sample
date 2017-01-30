//
//  FBSDKIcon.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/13/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSDKIcon : NSObject

- (instancetype)initWithColor:(UIColor *)color NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) UIColor *color;

- (UIImage *)imageWithSize:(CGSize)size;

- (CGPathRef)pathWithSize:(CGSize)size;

@end
