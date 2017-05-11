//
//  ViewController.m
//  Ohana
//
//  Created by zhen gong on 5/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//@TODO: 1. null_resettable definition.
@property(nonatomic, strong, null_resettable) UITableView *tableView;

// @TODO: 2. IMPLEMENTED Ohana/Classes/Core/OHContactsDataSource
// Implemented OHContactsDataSource *dataSource

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
    
    // contact datasource
    // initDatasource()
    
    // Do any additional setup after loading the view, typically from a nib.
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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"test";
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end










