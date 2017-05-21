//
//  OHABAddressBookContactsDataProvider.h
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>


@class OHABAddressBookContactsDataProvider;

/**
 * dataProvider:requiresUserAuthentication: is called if the OHABAddressBookContactsDataProvider is unable to
 * access the system contacts because access has not yet been granted.
 * The consumer may chose to trigger the user authentication prompt by invoking the userAuthenticationTrigger
 * callback. Once the user has authenticated, contact loading will be attempted again.
 */
@protocol OHABAddressBookContactsDataProviderDelegate <NSObject>

@end

@interface OHABAddressBookContactsDataProvider : NSObject

// - (instancetype)initWithDelegate:(id<OHABAddressBookContactsDataProviderDelegate>)delegate NS_DESIGNATED_INITIALIZER;

// - (instancetype)init NS_UNAVAILABLE;

@end
