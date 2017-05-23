//
//  GZABAddressBookContactsDataProvider.h
//  Ohana
//
//  Created by zhen gong on 5/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//


#import <AddressBook/AddressBook.h>
#import "GZContactsDataProviderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

// @todo:Added a block to call back.
typedef void (^GZABContactsLoadingCompletionBlock)(NSOrderedSet<GZContact *> *records);

@class GZABAddressBookContactsDataProvider;

/**
 * dataProvider:requiresUserAuthentication: is called if the OHABAddressBookContactsDataProvider is unable to
 * access the system contacts because access has not yet been granted.
 * The consumer may chose to trigger the user authentication prompt by invoking the userAuthenticationTrigger
 * callback. Once the user has authenticated, contact loading will be attempted again.
 */

// delegate
@protocol GZABAddressBookContactsDataProviderDelegate <NSObject>

/**
 * dataProvider:requiresUserAuthentication: is called if the OHABAddressBookContactsDataProvider is unable to
 * access the system contacts because access has not yet been granted.
 * The consumer may chose to trigger the user authentication prompt by invoking the userAuthenticationTrigger
 * callback. Once the user has authenticated, contact loading will be attempted again.
 */
- (void)dataProviderHitABAddressBookAuthChallenge:(GZABAddressBookContactsDataProvider *)dataProvider requiresUserAuthentication:(void (^)())userAuthenticationTrigger;


//@todo: add delegate method to notify view controller that dataSource loading is finishe.d

// - (void)dataProviderFinishLoadingABAddressBook:(void (^)(NSOrderedSet<GZContact *> *))completionHandler;
- (void)dataProviderFinishLoadingABAddressBook:(NSOrderedSet<GZContact *> *) contacts;
@end

// object class has reference with delegate.
@interface GZABAddressBookContactsDataProvider : NSObject <GZContactsDataProviderProtocol>

 - (instancetype)initWithDelegate:(id<GZABAddressBookContactsDataProviderDelegate>)delegate NS_DESIGNATED_INITIALIZER;

 - (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy)GZABContactsLoadingCompletionBlock completionBlock;

@end

NS_ASSUME_NONNULL_END
