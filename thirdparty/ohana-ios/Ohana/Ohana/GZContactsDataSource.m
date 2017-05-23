//
//  GZContactsDataSource.m
//  Ohana
//
//  Created by zhen gong on 5/11/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "GZContactsDataSource.h"
#import "GZContact.h"

@interface GZContactsDataSource()

/**
 *  Read-only public properties
 */
// @todo:Why contacts and selectedContacts with readwrite here?
@property (nonatomic, readwrite, nullable) NSOrderedSet<GZContact *> *contacts;
@property (nonatomic, readwrite) NSMutableOrderedSet<GZContact *> *selectedContacts;

/**
 *  Used internally to store contacts while processing. Use the contacts property externally.
 */
@property (nonatomic) NSMutableOrderedSet<GZContact *> *allContacts;
@property (nonatomic, readwrite) NSOrderedSet<id<GZContactsDataProviderProtocol>> *dataProviders;
@property (nonatomic, readwrite, nullable) NSOrderedSet<id<GZContactsPostProcessorProtocol>> *postProcessors;
@property (nonatomic, readwrite) NSMutableSet<id<GZContactsDataProviderProtocol>> *completedDataProviders;
@property (nonatomic, readwrite) NSMutableSet<id<GZContactsPostProcessorProtocol>> *completedPostProcessors;

@end

@implementation GZContactsDataSource

- (instancetype)initWithDataProviders:(NSOrderedSet<id<GZContactsDataProviderProtocol>> *)dataProviders postProcessors:(NSOrderedSet<id<GZContactsPostProcessorProtocol>> *_Nullable)postProcessors
{
    if (dataProviders.count == 0) {
        [NSException raise:@"UBDataSource must have at least 1 data provider" format:@"%@", self];
    }
    if (self = [super init]) {
        _dataProviders = dataProviders;
        _postProcessors = postProcessors;
//        
//        _onContactsDataSourceReadySignal = [[OHContactsDataSourceReadySignal alloc] init];
//        _onContactsDataSourceSelectedContactsSignal = [[OHContactsDataSourceSelectedContactsSignal alloc] init];
//        _onContactsDataSourceDeselectedContactsSignal = [[OHContactsDataSourceDeselectedContactsSignal alloc] init];
        
        _allContacts = [[NSMutableOrderedSet<GZContact *> alloc] init];
        _selectedContacts = [[NSMutableOrderedSet alloc] init];
        
        
        _completedDataProviders = [[NSMutableSet<id<GZContactsDataProviderProtocol>> alloc] initWithCapacity:dataProviders.count];
        _completedPostProcessors = [[NSMutableSet<id<GZContactsPostProcessorProtocol>> alloc] initWithCapacity:postProcessors.count];
        
        // Iterate over data providers and subscribe to their onDataProviderFinishedLoadingSignal
        for (id<GZContactsDataProviderProtocol> dataProvider in _dataProviders) {
            // Add onFinishedLoadingSignal observers on each data provider
            [self _setupOnDataProviderFinishedLoadingSignalObserverForDataProvider:dataProvider];
        }
    }
    return self;
    
}

- (void)loadContacts
{
    for (id<GZContactsDataProviderProtocol> dataProvider in self.dataProviders) {
        [dataProvider loadContacts];
    }
}

#pragma mark - Private

- (void)_setupOnDataProviderFinishedLoadingSignalObserverForDataProvider:(id<GZContactsDataProviderProtocol>)dataProvider
{
    //@todo: study how to create a signal to call back and get the self.contacts.
    
    
//    [dataProvider dataProviderFinishLoadingABAddressBook:^{
//        self.contacts
//    }];
    
//    [dataProvider.onContactsDataProviderFinishedLoadingSignal addObserver:self callback:^(typeof(self) self, id<OHContactsDataProviderProtocol> dataProvider) {
//        [self.allContacts unionOrderedSet:dataProvider.contacts];
//        [self.completedDataProviders addObject:dataProvider];
//        if (self.completedDataProviders.count == self.dataProviders.count) {
//            
//            if (self.postProcessors.count) {
//                NSOrderedSet *postProcessedContacts = self.allContacts;
//                for (id<OHContactsPostProcessorProtocol> postProcessor in self.postProcessors) {
//                    postProcessedContacts = [postProcessor processContacts:postProcessedContacts];
//                }
//                self.contacts = postProcessedContacts;
//            } else {
//                self.contacts = self.allContacts;
//            }
//            
//            self.onContactsDataSourceReadySignal.fire(self.contacts);
//        }
//    }];
}

@end
