//
//  GZContactsDataProviderProtocol.h
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZContact.h"

//@note:status can be used as ENUM
typedef NS_ENUM(NSInteger, GZContactsDataProviderStatus) {
    GZContactsDataProviderStatusInitialized,
    GZContactsDataProviderStatusProcessing,
    GZContactsDataProviderStatusLoaded,
    GZContactsDataProviderStatusError
};

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OHContactsDataProviderErrorCode) {
    OHContactsDataProviderErrorCodeUnknown,            // Default
    OHContactsDataProviderErrorCodeAuthenticationError // Indicates that a failure occurred with authentication after (or before) an authentication challenge
};

extern NSString *const OHContactsDataProviderErrorDomain;

@protocol GZContactsDataProviderProtocol <NSObject>

/**
 *  Signal to be fired after the contacts data provider has finished loading (see signal definition)
 */
// @property (nonatomic, readonly) OHContactsDataProviderFinishedLoadingSignal *onContactsDataProviderFinishedLoadingSignal;

/**
 *  Signal to be fired after the contacts data provider has encountered an error (see signal definition)
 */
// @property (nonatomic, readonly) OHContactsDataProviderErrorSignal *onContactsDataProviderErrorSignal;

/**
 *  Status of the data provider
 */
@property (nonatomic, readonly) GZContactsDataProviderStatus status;

/**
 *  All contacts loaded by the data provider
 *
 *  @discussion This will be nil until onDataProviderFinishedLoadingSignal has fired
 */
@property (nonatomic, readonly, nullable) NSOrderedSet<GZContact *> *contacts;

/**
 *  Method to start the data provider loading contacts.
 *
 *  @discussion This method should start the loading process. If loading completes successfully, the contacts property should return a populated array of OHContacts
 *  and onDataProviderFinishedLoading should be fired. If an error occurs during loading, onDataProviderError should be fired.
 */
- (void)loadContacts;

/**
 * The identifier for this provider that will be assigned to contact fields and contact addresses returned by the provider
 *
 * @discussion This identifier should be unique across all data providers. We recommend using the class name.
 */
 + (NSString *)providerIdentifier;


@end

NS_ASSUME_NONNULL_END
