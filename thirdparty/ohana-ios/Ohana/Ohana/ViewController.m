//
//  ViewController.m
//  Ohana
//
//  Created by zhen gong on 5/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import "GZContactsDataProviderProtocol.h"
#import "GZABAddressBookContactsDataProvider.h"
#import "GZAlphabeticalSortPostProcessor.h"
#import "GZContactsDataSource.h"

@interface ViewController () <GZABAddressBookContactsDataProviderDelegate> {
    ABAddressBookRef _addressBook;
    NSDictionary *_contactDictioanry;
}

//@TODO: 1. null_resettable definition.
@property(nonatomic, strong, null_resettable) UITableView *tableView;

// @TODO: 2. Implemented GZContactsDataSource *dataSource
@property(nonatomic) GZContactsDataSource *dataSource;

// @note: cannot use self.dataSource.contacts = contacts because self.dataSource.contacts is readonly.
//
@property (nonatomic, readwrite, nullable) NSOrderedSet<GZContact *> *contacts;

// last version
@property (nonatomic, strong) NSArray* contactInfos;

@end

@implementation ViewController

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (instancetype)init {
    if(self = [super init]) {
        // 1: initialized dataProvder with protocol GZContactsDataProviderProtocol. GZABAddressBookContactsDataProvider implemented GZContactsDataProviderProtocol.
        // 2: initialized sortProcessor with sort Mode.
        
        //@todo:dataProvider is id with GZContactsDataProviderProtocol type.
        // initWithDelegate with self. passing id<GZABAddressBookContactsDataProviderDelegate> type self.
        // self implemented GZABAddressBookContactsDataProviderDelegate
        
        // GZABAddressBookContactsDataProvider:NSObject<GZContactsDataProviderProtocol>
        // initWithDelegate:self is it just same as the self.delegate = self;
        // self:ViewController implement GZABAddressBookContactsDataProviderDelegate.
        
        // GZABAddressBookContactsDataProvider extends NSObjet and implemented <GZContactsDataProviderProtocol>
        // GZABAddressBookContactsDataProvider initWithDelegate will return id type with GZContactsDataProviderProtocol.
        id<GZContactsDataProviderProtocol> dataProvider = [[GZABAddressBookContactsDataProvider alloc] initWithDelegate:self];
        
        GZAlphabeticalSortPostProcessor *alphabeticalSortProcessor = [[GZAlphabeticalSortPostProcessor alloc] initWithSortMode:GZAlphabeticalSortPostProcessorSortModeFullName];
        
        // 3: initialized dataSource with dataProviders and postProcessors
        _dataSource = [[GZContactsDataSource alloc] initWithDataProviders:[NSOrderedSet orderedSetWithObjects:dataProvider, nil]
                                                           postProcessors:[NSOrderedSet orderedSetWithObjects:alphabeticalSortProcessor, nil]];
        
        // 4: dataSource loadContacts.
        [self.dataSource loadContacts];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.dataSource.contacts) {
//        return [self.contactsByLetter count];
//    } else {
//        return 1;
//    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.dataSource.contacts count];
    return [self.contacts count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (self.contacts) {
        GZContact *contact = [self.contacts objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [self _displayNameForContact:contact];
        cell.imageView.image = contact.thumbnailPhoto;
    } else {
        cell.textLabel.text = @"No contacts access, open Settings app to fix this";
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}

- (void)promptForAddressBookRequestAccess {
    ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted == NO) {

            } else {
                NSLog(@"Just authorized");
               [self getAuthorizedToshowContacts];
            }
        });
    });
}


-(void)getAuthorizedToshowContacts {
    CFErrorRef addressBookError = NULL;
    _addressBook = ABAddressBookCreateWithOptions(NULL, &addressBookError);
    
    if (_addressBook != nil) {
        NSMutableArray *_contactNames = [NSMutableArray array];
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBook);
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++) {
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            // email
            ABMutableMultiValueRef emailsRef = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            if (ABMultiValueGetCount(emailsRef) > 0) {
                // GetContactEntity *contact = [[GetContactEntity alloc] init];
                CFTypeRef tmp = NULL;
                
                NSString *fullName = @"";
                tmp = ABRecordCopyCompositeName(contactPerson);
                if (tmp) {
                    fullName = [NSString stringWithString:(__bridge NSString * _Nonnull)(tmp)];
                    CFRelease(tmp);
                    tmp = NULL;
                    [_contactNames addObject:fullName];
                }
            }
        }
        _contactInfos = [_contactNames copy];
    } else {
        DLog(@"addressBool is nil");
    }
}

- (NSString *)_displayNameForContact:(GZContact *)contact
{
    if (contact.fullName.length) {
        return contact.fullName;
    }
    if (contact.contactFields.count) {
        return [contact.contactFields objectAtIndex:0].value;
    }
    return nil;
}

#pragma mark - GZABAddressBookContactsDataProviderDelegate

// delegate GZABAddressBookContactsDataProviderDelegate impment method here.

- (void)dataProviderHitABAddressBookAuthChallenge:(GZABAddressBookContactsDataProvider *)dataProvider requiresUserAuthentication:(void (^)())userAuthenticationTrigger
{
    userAuthenticationTrigger();
}

//@todo: Added delegate method for preparing dataSource.contacts loading.
- (void)dataProviderFinishLoadingABAddressBook:(NSOrderedSet<GZContact *> *)contacts
{   DLog(@"%@", self.dataSource.contacts);
    self.contacts = contacts;
}

@end
