//
//  SystemUtils.m
//  CaknowGZ
//
//  Created by gongzhen on 3/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "SystemUtils.h"

@implementation SystemUtils

+ (NSString *)capitalizeFirstLetter:(NSString *)string {
    NSString *result = string;
    result = [NSString stringWithFormat:@"%@%@", [[string substringToIndex:1] uppercaseString], [string substringFromIndex:1]];
    return result;
}

@end
