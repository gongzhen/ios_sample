//
//  GZContactsDataSource.h
//  Ohana
//
//  Created by zhen gong on 5/11/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GZContactsSelectionFilterProtocol.h"
#import "GZContactsPostProcessorProtocol.h"
#import "GZContactsDataProviderProtocol.h"

//@TODO: DAY 1 IMPLEMENTED DATASOURCE

NS_ASSUME_NONNULL_BEGIN

@interface GZContactsDataSource : NSObject

/**
 *  Ordered set of selection filters
 *
 *  @discussion The selection filters can be updated at any time
 */
@property (nonatomic, nullable) NSOrderedSet<id<GZContactsSelectionFilterProtocol>> *selectionFilters;

/**
 *  Signal fired after the data source is ready to be used
 *
 *  @discussion When this signal is fired, the `contacts` property will have been set
 */
// @property (nonatomic, readonly) OHContactsDataSourceReadySignal *onContactsDataSourceReadySignal;

/**
 *  Signal fired after the data source selects contacts
 */
// @property (nonatomic, readonly) OHContactsDataSourceSelectedContactsSignal *onContactsDataSourceSelectedContactsSignal;

/**
 *  Signal fired after the data source deselects contacts
 */
// @property (nonatomic, readonly) OHContactsDataSourceDeselectedContactsSignal *onContactsDataSourceDeselectedContactsSignal;

/**
 *  Ordered set of contacts received from the data providers and processed by the post processors
 *
 *  @discussion This will be nil until loadContacts is called
 */
 @property (nonatomic, readonly, nullable) NSOrderedSet<GZContact *> *contacts;

/**
 *  Set of selected contacts
 */
@property (nonatomic, readonly) NSOrderedSet<GZContact *> *selectedContacts;

/**
 *  Contact filtering block used in the contactsPassingFilter method
 *
 *  @param contact The contact being filtered on
 *
 *  @return A boolean representing if the contact passes the filter or not
 */
//typedef BOOL (^FilterContactsBlock)(OHContact *contact);

/**
 *  Designated initalizer for contact data source
 *
 *  @discussion You must provide at least one data provider.
 *
 *  @param dataProviders    An ordered set of objects conforming to the UBCLContactsDataProviderProtocol, will be used to populate contact data in the data source
 *  @param postProcessors   An ordered set of postprocessors to run on the data from the UBCLContactsDataProviderProtocol objects (optional)
 *
 *  @return an instance of UBContactsDataSource
 */
- (instancetype)initWithDataProviders:(NSOrderedSet<id<GZContactsDataProviderProtocol>> *)dataProviders postProcessors:(NSOrderedSet<id<GZContactsPostProcessorProtocol>> *_Nullable)postProcessors NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience initalizer for contact data source with selection filters
 *
 *  @discussion You must provide at least one data provider.
 *
 *  @param dataProviders    An ordered set of objects conforming to the UBCLContactsDataProviderProtocol, will be used to populate contact data in the data source
 *  @param postProcessors   An ordered set of postprocessors to run on the data from the UBCLContactsDataProviderProtocol objects (optional)
 *  @param selectionFilters An ordered set of selection filters to filter contacts before selection or deselection occurs (optional)
 */
//- (instancetype)initWithDataProviders:(NSOrderedSet<id<OHContactsDataProviderProtocol>> *)dataProviders postProcessors:(NSOrderedSet<id<OHContactsPostProcessorProtocol>> *_Nullable)postProcessors selectionFilters:(NSOrderedSet<id<OHContactsSelectionFilterProtocol>> *_Nullable)selectionFilters;

// This init method has to add to in case that the warning below comes out.
// Method override for the designated initializer of the superclass '-init' not found
- (instancetype)init NS_UNAVAILABLE;

/**
 *  Tells the data source to begin loading contacts data from the data providers and then pass that contact data through the post processors.
 *  This method fires several important events that should be observed on to act on the contact data, see above for more information on the available signals.
 */
- (void)loadContacts;

/**
 *  Method used to filter on the contacts in the data source, each contact in the data source will be passed through
 *  the provided filterContactsBlock and this method will return contacts that pass that block
 *
 *  @param filterContactsBlock Filtering block that returns a boolean noting if the filter passed or not on the provided contact
 *
 *  @return Ordered set of contacts passing the filterContactsBlock
 */
//- (NSOrderedSet<OHContact *> *)contactsPassingFilter:(FilterContactsBlock)filterContactsBlock;

/**
 *  Marks a set of contacts as selected in the data source
 *
 *  @discussion The contacts will be passed through the selection filters before being selected
 *
 *  @param contacts The contacts that will be selected
 */
//- (void)selectContacts:(NSOrderedSet<OHContact *> *)contacts;

/**
 *  Unmarks a set of contacts as selected in the data source
 *
 *  @discussion The contacts will be passed through the selection filters before being deselected
 *
 *  @param contacts The contacts that will be deselected
 */
//- (void)deselectContacts:(NSOrderedSet<OHContact *> *)contacts;

@end

NS_ASSUME_NONNULL_END
