//
//  GZABAddressBookContactsDataProvider.m
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "GZABAddressBookContactsDataProvider.h"
#import "GZContactsDataProviderProtocol.h"
#import "GZContactField.h"

@interface GZABAddressBookContactsDataProvider()

/**
 * Executed when we have loaded the user's contacts list
 *
 * @param records Ordered set of ABRecordRef objects representing the user's contacts list
 */

typedef void (^GZABContactsFetchCompletionBlock)(NSOrderedSet<GZContact *> *records);

/**
 * Executed if there's an issue with loading the contact list
 *
 * @param error An NSError detailing the issue
 */

typedef void (^GZABContactsFetchFailedBlock)(NSError *error);

@property(nonatomic, weak, readonly) id<GZABAddressBookContactsDataProviderDelegate> delegate;

@end

@implementation GZABAddressBookContactsDataProvider

@synthesize status = _status, contacts = _contacts;

- (instancetype)initWithDelegate:(id<GZABAddressBookContactsDataProviderDelegate>)delegate
{
    if (self = [super init]) {
//        _onContactsDataProviderFinishedLoadingSignal = [[OHContactsDataProviderFinishedLoadingSignal alloc] init];
//        _onContactsDataProviderErrorSignal = [[OHContactsDataProviderErrorSignal alloc] init];
//        _status = OHContactsDataProviderStatusInitialized;
        _delegate = delegate;
    }
    return self;
}

#pragma mark - GZContactsDataProviderProtocol

- (void)loadContacts
{
    //@note: Added status wrapper for Address Book.
    if ([self _authorizationStatus] == kABAuthorizationStatusNotDetermined) {
        __weak typeof(self) weakSelf = self;
        [self.delegate dataProviderHitABAddressBookAuthChallenge:self requiresUserAuthentication:^{
            [weakSelf triggerUserAuthentication];
        }];
    } else if ([self _authorizationStatus] == kABAuthorizationStatusAuthorized) {
        _status = GZContactsDataProviderStatusProcessing;
        [self _fetchContactsWithSuccess:^(NSOrderedSet<GZContact *> *records) {
            _contacts = records;
            _status = GZContactsDataProviderStatusLoaded;
            
            // @todo: How to add a completion call back to inform GZContactsDataSource that contacts are finishied.
            if(_completionBlock) {
                _completionBlock(_contacts);
            }
            
            // self.delegate.fire something here.
            // self.onContactsDataProviderFinishedLoadingSignal.fire(self);
        } failure:^(NSError *error) {
            _status = GZContactsDataProviderStatusError;
//            self.onContactsDataProviderErrorSignal.fire(error, self);
        }];
    } else {
        _status = GZContactsDataProviderStatusError;
//        self.onContactsDataProviderErrorSignal.fire([NSError errorWithDomain:OHContactsDataProviderErrorDomain code:OHContactsDataProviderErrorCodeAuthenticationError userInfo:nil], self);
    }
}

+ (NSString *)providerIdentifier
{
    return NSStringFromClass([GZABAddressBookContactsDataProvider class]);
}

#pragma mark - Private

- (void)triggerUserAuthentication
{
    ABAddressBookRequestAccessWithCompletion(nil, ^(bool granted, CFErrorRef error) {
        if (granted) {
            [self loadContacts];
        }
    });
}

// GZABContactsFetchCompletionBlock's parameters are NSOrderedSet<GZContact *> *records.
- (void)_fetchContactsWithSuccess:(GZABContactsFetchCompletionBlock)success failure:(GZABContactsFetchFailedBlock)failure
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    [self _requestAddressBookAccessWithAddressBook:addressBook completion:^(bool granted, CFErrorRef error) {
        if (granted && !error) {
            [self _readAddressBookContacts:addressBook completion:^(NSOrderedSet<GZContact *> *records) {
                success(records);
            }];
        } else {
            _status = GZContactsDataProviderStatusError;
            failure((__bridge NSError *)error);
        }
        if (addressBook) {
            CFRelease(addressBook);
        }
    }];
}

- (void)_readAddressBookContacts:(ABAddressBookRef)addressBook completion:(void (^)(NSOrderedSet<GZContact *> *records))completion
{
    CFArrayRef peopleRecordRefs = [self _copyArrayOfAllPeopleFromAddressBook:addressBook];
    if (peopleRecordRefs) {
        long peopleRecordRefsCount = CFArrayGetCount(peopleRecordRefs);
        NSMutableOrderedSet<GZContact *> *ubContactsArray = [NSMutableOrderedSet orderedSetWithCapacity:(NSUInteger)peopleRecordRefsCount];
        for (long i = 0; i < peopleRecordRefsCount; i++) {
            [ubContactsArray addObject:[self _transformABRecordToOHContactWithRecord:CFArrayGetValueAtIndex(peopleRecordRefs, i)]];
        }
        completion(ubContactsArray);
        CFRelease(peopleRecordRefs);
    } else {
        completion(nil);
    }
}

- (GZContact *)_transformABRecordToOHContactWithRecord:(ABRecordRef)record
{
    GZContact *contact = [[GZContact alloc] init];
    contact.firstName = [self _stringForABPropertyId:kABPersonFirstNameProperty record:record];
    contact.lastName = [self _stringForABPropertyId:kABPersonLastNameProperty record:record];
    contact.fullName = [self _fullNameForRecord:record];
    contact.thumbnailPhoto = [self _thumbnailPictureForRecord:record];
    
    NSMutableOrderedSet *contactFields = [[NSMutableOrderedSet alloc] init];
    [contactFields addObjectsFromArray:[self _createContactFieldsForPhoneNumbersFromRecord:record]];
    [contactFields addObjectsFromArray:[self _createContactFieldsForEmailsFromRecord:record]];
    
    contact.contactFields = contactFields;
    
    return contact;
}

- (NSArray<GZContactField *> *)_createContactFieldsForPhoneNumbersFromRecord:(ABRecordRef)record
{
    ABMultiValueRef multiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
    NSMutableArray<GZContactField *> *fieldsArray = nil;
    if (multiValue) {
        CFIndex fieldCount = ABMultiValueGetCount(multiValue);
        fieldsArray = [[NSMutableArray alloc] initWithCapacity:(NSUInteger)fieldCount];
        
        for (CFIndex i = 0; i < fieldCount; i++) {
            NSString *label = @"mobile";
            CFStringRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, i);
            if (rawLabel) {
                label = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(rawLabel);
                CFRelease(rawLabel);
            }
            NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            GZContactField *contactField = [[GZContactField alloc] initWithType:GZContactFieldTypePhoneNumber label:label value:value dataProviderIdentifier:[GZABAddressBookContactsDataProvider providerIdentifier]];
            [fieldsArray addObject:contactField];
        }
        CFRelease(multiValue);
    }
    
    return fieldsArray;
}

- (NSArray<GZContactField *> *)_createContactFieldsForEmailsFromRecord:(ABRecordRef)record
{
    ABMultiValueRef multiValue = ABRecordCopyValue(record, kABPersonEmailProperty);
    NSMutableArray<GZContactField *> *fieldsArray = nil;
    if (multiValue) {
        CFIndex fieldCount = ABMultiValueGetCount(multiValue);
        fieldsArray = [[NSMutableArray alloc] init];
        
        for (CFIndex i = 0; i < fieldCount; i++) {
            NSString *value = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, i);
            
            NSString *label = @"email";
            CFStringRef rawLabel = ABMultiValueCopyLabelAtIndex(multiValue, i);
            if (rawLabel) {
                label = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(rawLabel);
                CFRelease(rawLabel);
            }
            
            GZContactField *contactField = [[GZContactField alloc] initWithType:GZContactFieldTypeEmailAddress label:label value:value dataProviderIdentifier:[GZABAddressBookContactsDataProvider providerIdentifier]];
            [fieldsArray addObject:contactField];
        }
        CFRelease(multiValue);
    }
    
    return fieldsArray;
}


#pragma mark - Private - Address Book Wrappers

- (ABAuthorizationStatus)_authorizationStatus
{
    return ABAddressBookGetAuthorizationStatus();
}

- (void)_requestAddressBookAccessWithAddressBook:(ABAddressBookRef)addressBook completion:(void (^)(bool granted, CFErrorRef error))completion
{
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        completion(granted, error);
    });
}

- (ABPersonCompositeNameFormat)_getPersonCompositeNameFormatForRecord:(ABRecordRef)record
{
    return ABPersonGetCompositeNameFormatForRecord(record);
}

- (CFArrayRef)_copyArrayOfAllPeopleFromAddressBook:(ABAddressBookRef)addressBook
{
    return ABAddressBookCopyArrayOfAllPeople(addressBook);
}

#pragma mark - Private - ABRecordRef Parsing


- (NSString *)_stringForABPropertyId:(ABPropertyID)propertyId record:(ABRecordRef)record
{
    NSString *string = (__bridge_transfer NSString *)ABRecordCopyValue(record, propertyId);
    if (!string.length) {
        return nil;
    }
    
    return string;
}

- (NSString *)_fullNameForRecord:(ABRecordRef)record
{
    NSString *fullName = nil;
    NSString *firstName = [self _stringForABPropertyId:kABPersonFirstNameProperty record:record];
    NSString *lastName = [self _stringForABPropertyId:kABPersonLastNameProperty record:record];
    
    if (firstName.length && lastName.length) {
        if ([self _getPersonCompositeNameFormatForRecord:record] == kABPersonCompositeNameFormatFirstNameFirst) {
            fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        } else {
            fullName = [NSString stringWithFormat:@"%@, %@", lastName, firstName];
        }
    } else if (firstName.length) {
        fullName = firstName;
    } else if (lastName.length) {
        fullName = lastName;
    }
    
    return fullName;
}

- (UIImage *)_thumbnailPictureForRecord:(ABRecordRef)record
{
    UIImage *picture = nil;
    if (ABPersonHasImageData(record)) {
        NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail);
        picture = [UIImage imageWithData:imageData];
    }
    
    return picture;
}

@end
