//
//  GZContact.m
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "GZContact.h"

@interface GZContact ()

// @todo: why to put tags and customProperties here with readwrite?
@property (nonatomic, readwrite) NSMutableSet<NSString *> *tags;
@property (nonatomic, readwrite) NSMutableDictionary<NSString *, id> *customProperties;

@end

@implementation GZContact

//
- (NSMutableSet<NSString *> *)tags
{
    if (!_tags) {
        _tags = [[NSMutableSet<NSString *> alloc] init];
    }
    return _tags;
}

- (NSMutableDictionary<NSString *, id> *)customProperties
{
    if (!_customProperties) {
        _customProperties = [[NSMutableDictionary<NSString *, id> alloc] init];
    }
    return _customProperties;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    GZContact *copy = [[GZContact alloc] init];
    copy.fullName = [self.fullName copy];
    copy.firstName = [self.firstName copy];
    copy.lastName = [self.lastName copy];
    copy.organizationName = [self.organizationName copy];
    copy.jobTitle = [self.jobTitle copy];
    copy.departmentName = [self.departmentName copy];
    copy.contactFields = [self.contactFields copy];
    copy.postalAddresses = [self.postalAddresses copy];
    copy.thumbnailPhoto = [self.thumbnailPhoto copy];
    copy.tags = [self.tags mutableCopy];
    copy.customProperties = [self.customProperties mutableCopy];
    return copy;
}

#pragma mark - Equality

- (BOOL)isEqualToContact:(GZContact *)contact
{
    return  ((!self.fullName && !contact.fullName) || [self.fullName isEqualToString:contact.fullName]) &&
    ((!self.firstName && !contact.firstName) || [self.firstName isEqualToString:contact.firstName]) &&
    ((!self.lastName && !contact.lastName) || [self.lastName isEqualToString:contact.lastName]) &&
    ((!self.organizationName && !contact.organizationName) || [self.organizationName isEqualToString:contact.organizationName]) &&
    ((!self.jobTitle && !contact.jobTitle) || [self.jobTitle isEqualToString:contact.jobTitle]) &&
    ((!self.departmentName && !contact.departmentName) || [self.departmentName isEqualToString:contact.departmentName]) &&
    [self _contactFieldsIsEqualToContactFields:contact.contactFields] &&
    [self _postalAddressesIsEqualToPostalAddresses:contact.postalAddresses] &&
    [self _thumbnailImageIsEqualToThumbnailImage:contact.thumbnailPhoto] &&
    [self.tags isEqualToSet:contact.tags] &&
    [self.customProperties isEqualToDictionary:contact.customProperties];
}

- (BOOL)_contactFieldsIsEqualToContactFields:(NSOrderedSet<GZContactField *> *)contactFields
{
    if (!self.contactFields && !contactFields) {
        return YES;
    }
    if (self.contactFields.count != contactFields.count) {
        return NO;
    }
    for (NSUInteger i = 0 ; i < self.contactFields.count ; i++) {
//        if (![[self.contactFields objectAtIndex:i] isEqualToContactField:[contactFields objectAtIndex:i]]) {
//            return NO;
//        }
    }
    return YES;
}

- (BOOL)_postalAddressesIsEqualToPostalAddresses:(NSOrderedSet<GZContactAddress *> *)postalAddresses
{
    if (!self.postalAddresses && !postalAddresses) {
        return YES;
    }
    if (self.postalAddresses.count != postalAddresses.count) {
        return NO;
    }
    for (NSUInteger i = 0 ; i < self.postalAddresses.count ; i++) {
//        if (![[self.postalAddresses objectAtIndex:i] isEqualToContactAddress:[postalAddresses objectAtIndex:i]]) {
//            return NO;
//        }
    }
    return YES;
}

- (BOOL)_thumbnailImageIsEqualToThumbnailImage:(UIImage *)thumbnailPhoto
{
    if (self.thumbnailPhoto && thumbnailPhoto) {
        NSData *selfData = UIImagePNGRepresentation(self.thumbnailPhoto);
        NSData *otherData = UIImagePNGRepresentation(thumbnailPhoto);
        
        return [selfData isEqualToData:otherData];
    }
    return self.thumbnailPhoto == nil && thumbnailPhoto == nil;
}

@end
