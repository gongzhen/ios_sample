//
//  SystemUtils.m
//  CaknowGZ
//
//  Created by gongzhen on 3/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "SystemUtils.h"
#import "BaseEntity.h"

@implementation SystemUtils

+ (NSString *)capitalizeFirstLetter:(NSString *)string {
    NSString *result = string;
    result = [NSString stringWithFormat:@"%@%@", [[string substringToIndex:1] uppercaseString], [string substringFromIndex:1]];
    return result;
}

+ (Boolean)isArrayClass:(id)classObject {
    return [classObject isKindOfClass:[NSArray class]];
}

+ (Boolean)isDictionaryClass:(id)classObject {
    return [classObject isKindOfClass:[NSDictionary class]];
}

+ (Boolean)isBaseClass:(id)classObject {
    return [classObject isKindOfClass:[BaseEntity class]];
}

@end
