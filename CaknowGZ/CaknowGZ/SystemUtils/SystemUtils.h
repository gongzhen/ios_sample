//
//  SystemUtils.h
//  CaknowGZ
//
//  Created by gongzhen on 3/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemUtils : NSObject

+ (NSString *)capitalizeFirstLetter:(NSString *)string;

+ (Boolean)isArrayClass:(id)classObject;

+ (Boolean)isDictionaryClass:(id)classObject;

+ (Boolean)isBaseClass:(id)classObject;


@end
