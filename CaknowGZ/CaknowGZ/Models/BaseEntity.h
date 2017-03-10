//
//  BaseEntity.h
//  CaknowGZ
//
//  Created by gongzhen on 3/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject

@property (nonatomic, strong) NSString *message;

- (void)setAttributes:(NSDictionary *)dictionary;

+ (instancetype)getObject:(NSDictionary *)dictionary;

- (NSString *)description;

@end
