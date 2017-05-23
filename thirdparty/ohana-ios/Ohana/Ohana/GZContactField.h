//
//  GZContactField.h
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GZContactFieldType) {
    GZContactFieldTypePhoneNumber = 0,
    GZContactFieldTypeEmailAddress,
    GZContactFieldTypeURL,
    GZContactFieldTypeOther
};


@interface GZContactField : NSObject

/**
 *  Creates the contact field object
 */
- (instancetype)initWithType:(GZContactFieldType)type label:(NSString *)label value:(NSString *)value dataProviderIdentifier:(NSString *)dataProviderIdentifier NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/**
 *  Type of contact field (see enum above for options)
 */
@property (nonatomic, readonly) GZContactFieldType type;

/**
 *  Label (i.e. "home", "work")
 */
@property (nonatomic, readonly) NSString *label;

/**
 *  Value
 */
@property (nonatomic, readonly) NSString *value;

/**
 *  Identifier of the data provider that created the contact field
 */
@property (nonatomic, readonly) NSString *dataProviderIdentifier;

@end
