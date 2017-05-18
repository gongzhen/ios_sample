//
//  ViewController.m
//  Ohana
//
//  Created by zhen gong on 5/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>

@interface ViewController () {
    ABAddressBookRef _addressBook;
    NSDictionary *_contactDictioanry;
}

//@TODO: 1. null_resettable definition.
@property(nonatomic, strong, null_resettable) UITableView *tableView;

// @TODO: 2. IMPLEMENTED Ohana/Classes/Core/OHContactsDataSource
// Implemented OHContactsDataSource *dataSource
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    // Get contact permission.
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    
    switch (authorizationStatus) {
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
            NSLog(@"Denied");
            [self promptForAddressBookRequestAccess];
            break;
        case kABAuthorizationStatusNotDetermined:
            NSLog(@"Not Determined");
            [self promptForAddressBookRequestAccess];
            break;
        case kABAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            [self getAuthorizedToshowContacts];
            break;
    }
    
    // contact datasource
    // initDatasource()
    
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)initDatasource {
    
    // Implemented OHContactsDataProviderProtocol and create dataProvider
    // if CNContact class to generate dataProvider
    // Implemented OHCNContactsDataProvider or OHABAddressBookContactsDataProvider.
    // Implemented OHAlphabeticalSortPostProcessor alphabeticalSortProcessor
    // Created _dataSource comes from dataProvider and alphabeticalSortProcessor
    // Implemented onContactsDataSourceReadySignal for dataSource
    
    // dataSource.onContactsDataSourceReadySingal
    // dataSource.onContactsDataSourceSelectedContactsSingal addObserver
    // dataSource.onContactsDataSourceSelectedContactsSignal
    // dataSource loadContacts
}

#pragma mark - table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contactInfos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = (NSString *)[_contactInfos objectAtIndex:indexPath.row];
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

@end










