//
//  FBSDKMath.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//
#import "CoreGraphics/CoreGraphics.h"
#import <Foundation/Foundation.h>

@interface FBSDKMath : NSObject

+ (CGPoint)ceilForPoint:(CGPoint)value;
+ (CGSize)ceilForSize:(CGSize)value;
+ (CGPoint)floorForPoint:(CGPoint)value;
+ (CGSize)floorForSize:(CGSize)value;
+ (NSUInteger)hashWithCGFloat:(CGFloat)value;
+ (NSUInteger)hashWithCString:(const char *)value;
+ (NSUInteger)hashWithDouble:(double)value;
+ (NSUInteger)hashWithFloat:(float)value;
+ (NSUInteger)hashWithInteger:(NSUInteger)value;
+ (NSUInteger)hashWithInteger:(NSUInteger)value1 andInteger:(NSUInteger)value2;
+ (NSUInteger)hashWithIntegerArray:(NSUInteger *)values count:(NSUInteger)count;
+ (NSUInteger)hashWithLong:(unsigned long long)value;
+ (NSUInteger)hashWithPointer:(const void *)value;

@end
