//
//  GZContact.h
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZContactField.h"
#import "GZContactAddress.h"

NS_ASSUME_NONNULL_BEGIN

//@todo: NSCopying interface has to be reviewed.

@interface GZContact : NSObject <NSCopying>

/**
 *	Contact's full name
 */
@property (nonatomic, nullable, copy) NSString *fullName;

/**
 *	Contact's first name
 */
@property (nonatomic, nullable, copy) NSString *firstName;

/**
 *	Contact's last name
 */
@property (nonatomic, nullable, copy) NSString *lastName;

/**
 *  Organization name
 */
@property (nonatomic, nullable, copy) NSString *organizationName;

/**
 *  Job title
 */
@property (nonatomic, nullable, copy) NSString *jobTitle;

/**
 *  Department name
 */
@property (nonatomic, nullable, copy) NSString *departmentName;

/**
 *  Contact fields associated with the contact
 */
@property (nonatomic, nullable, copy) NSOrderedSet<GZContactField *> *contactFields;

/**
 *  Postal addresses associated with the contact
 */
@property (nonatomic, nullable, copy) NSOrderedSet<GZContactAddress *> *postalAddresses;

/**
 *  Thumbnail photo
 */
@property (nonatomic, nullable, copy) UIImage *thumbnailPhoto;

/**
 *  Set of custom tags (may be added by data providers, post processors, etc.)
 */
// @note: There is no setter for it at all for readonly
@property (nonatomic, readonly) NSMutableSet<NSString *> *tags;

/**
 *  Set of custom properties (may be added by data providers, post processors, etc.)
 */
// @note: There is no setter for it at all for readonly
@property (nonatomic, readonly) NSMutableDictionary<NSString *, id> *customProperties;

- (BOOL)isEqualToContact:(GZContact *)contact;


@end

NS_ASSUME_NONNULL_END
