//
//  FBSDKTypeUtility.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDKTypeUtility : NSObject

+ (NSArray *)arrayValue:(id)object;
+ (BOOL)boolValue:(id)object;
+ (NSDictionary *)dictionaryValue:(id)object;
+ (NSInteger)integerValue:(id)object;
+ (id)objectValue:(id)object;
+ (NSString *)stringValue:(id)object;
+ (NSTimeInterval)timeIntervalValue:(id)object;
+ (NSUInteger)unsignedIntegerValue:(id)object;
+ (NSURL *)URLValue:(id)object;

@end
