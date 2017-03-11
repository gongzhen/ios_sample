//
//  BaseEntity.m
//  CaknowGZ
//
//  Created by gongzhen on 3/9/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "BaseEntity.h"
#import "SystemUtils.h"
#import <objc/runtime.h>

@implementation BaseEntity

+ (instancetype)getObject:(NSDictionary *)dictionary {
    return [[BaseEntity alloc] init];
}

- (void)setAttributes:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *methodName = [self constructMethod];
    NSArray *allKeys = [dictionary allKeys];
    
    for (NSString *key in allKeys) {
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            id value = [dictionary objectForKey:key];
            
            if ([SystemUtils isDictionaryClass:value]) {
                NSString *className = [self constructClassNameFromMethod:methodName key:[SystemUtils capitalizeFirstLetter:key]];DLog(@"%@", className);
                Class objectClass = NSClassFromString(className);
                if (!objectClass) {
                    return;
                }
                id valueEntity = [[objectClass alloc] init];
                if ([valueEntity isKindOfClass:[BaseEntity class]]) {
                    [valueEntity performSelector:@selector(setAttributes:) withObject:value];
                }
                [self setValue:valueEntity forKey:key];
            } else if ([SystemUtils isArrayClass:value]) {
                NSMutableArray *valueArray = [NSMutableArray array];
                NSString *className = [self constructClassNameFromMethod:methodName key:[SystemUtils capitalizeFirstLetter:[key stringByReplacingOccurrencesOfString:@"_" withString:@""]]];
                Class objectClass = NSClassFromString(className);
                if(!objectClass) {
                    valueArray = value;
                } else {
                    for (id listMember in value) {
                        if ([SystemUtils isDictionaryClass:listMember]) {
                            id resultEntity = [[objectClass alloc] init];
                            if ([SystemUtils isBaseClass:resultEntity]) {
                                [resultEntity performSelector:@selector(setAttributes:) withObject:listMember];
                            }
                            [valueArray addObject:resultEntity];
                        } else {
                            [valueArray addObject:listMember];
                        }
                    }
                }
                [self setValue:valueArray forKey:key];
            } else {
                [self setValue:[dictionary objectForKey:key] forKey:key];
            }
        }
    }
}

- (NSString *)description {
    NSString *result = [super description];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        result = [result stringByAppendingFormat:@"%@ = %@\r", propertyName, [self valueForKey:propertyName]];
    }
    free(properties);
    return result;
}

- (NSString *)constructMethod {
    NSString *methodName = [[NSStringFromClass(self.class) componentsSeparatedByString:@"Entity"] objectAtIndex:0];
    if (!methodName) {
        methodName = @"";
    }
    return methodName;
}
                                       
- (NSString *)constructClassNameFromMethod:(NSString *)methodName key:(NSString *)key {
    return [NSString stringWithFormat:@"%@%@Entity", methodName, key];
}

@end
