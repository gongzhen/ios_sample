//
//  ProfessionalRegistrationViewController.m
//  ViewControllerTransition
//
//  Created by zhen gong on 7/14/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ProfessionalRegistrationViewController.h"
#import "CustomTableViewCell.h"

@interface ProfessionalRegistrationViewController () <UITableViewDelegate, UITableViewDataSource, CustomTableViewCellDelegate> {
    CGRect _tableCellRect;
    NSInteger _mHeight;
}
@property(strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray* dataSource;
@property (strong, nonatomic) NSMutableSet* pricingDataSourceSet;

@end

@implementation ProfessionalRegistrationViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableCellRect = CGRectMake(0, 0, self.view.bounds.size.width, 100);
    [self initDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    NSLog(@"numberSection:%ld", _dataSource.count);
    return _dataSource.count;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        static NSString *cellIdentifier = @"proServicesCell";
        
        // Similar to UITableViewCell, but
        CustomTableViewCell *cell = (CustomTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
        }
        NSDictionary* obj = [_dataSource objectAtIndex:indexPath.section];
        [cell updateWithFrame:_tableCellRect title:[obj valueForKey:@"name"] image:[obj valueForKey:@"pic"] options:[obj valueForKey:@"options"] andIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @autoreleasepool {
        // remove options of all expanded cells
//        [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof ProServicesTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [obj doRemoveOptions];
//        }];
//        ProServicesTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (cell.bounds.size.height > 120.0f) {
//            [self.tableView beginUpdates];
//            [self.tableView deselectRowAtIndexPath: indexPath animated: YES];
//            [self.tableView endUpdates];
//            return;
//        }
//        [cell doShowOptions];
//        [self updateTableView];
//        if (indexPath.section >= _mHeight) {
//            // shift tv up 128px
//            CGPoint p = self.view.center;
//            p.x = 0;
//            [tableView setContentOffset:p animated:YES];
//        }
    }
}

- (void)updateTableView
{
    @autoreleasepool {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark 

-(void)proObjectInit:(NSDictionary *)user {
    if (user == nil) return;
    NSLog(@"%@", user);
}

#pragma mark - 

- (void)didSelectService:(NSString *)option {
    if ([_pricingDataSourceSet containsObject:option] == true) {
        return;
    }
    
    [_pricingDataSourceSet addObject:option];
    [_pricingDataSourceSet enumerateObjectsUsingBlock:^(__kindof NSString* _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"obj:%@", obj);
    }];
    NSLog(@"didSelectService: %@ setCount: %lu", option, (unsigned long)[_pricingDataSourceSet count]);
}

- (void)didRemoveService:(NSString *)option {
    [_pricingDataSourceSet removeObject:option];
    [_pricingDataSourceSet enumerateObjectsUsingBlock:^(__kindof NSString* _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"obj:%@", obj);
    }];
    NSLog(@"didRemoveService: %@ setCount: %lu", option, (unsigned long)[_pricingDataSourceSet count]);
}

- (void)initDataSource {
    NSArray* hairOptions = @[
                             @"BARBER",
                             @"HAIRCUT",
                             @"HAIR\nEXTENSIONS",
                             @"TWISTS",
                             @"COLOR",
                             @"NATURAL\nHAIR",
                             @"STYLE",
                             @"STRAIGHTEN",
                             @"BRAIDS",
                             @"WEAVES"
                             ];
    
    NSArray* makeUpOptions = @[
                               @"FULL\nFACE",
                               @"GLAM",
                               @"AIR BRUSH",
                               @"WEDDING"
                               ];
    
    NSArray* careOptions = @[
                             @"NAILS",
                             @"ESTHETICIAN",
                             @"MASSAGE",
                             @"TANNING"
                             ];
    
    //            NSArray* eventsOptions = @[
    //                                       @"WEDDING",
    //                                       @"SPA DAY",
    //                                       @"CHILD\nBIRTHDAY",
    //                                       @"QUINCEANERA",
    //                                       @"BAT MITZVA"
    //                                       ];
    
    NSArray* eventsOptions = @[
                               @"COMING SOON"
                               ];
    
    NSArray* childrenOptions = @[
                                 @"TODDLERS",
                                 @"TEENAGE\nBOYS",
                                 @"TEENAGE\nGIRLS",
                                 @"YOUNG\nBOYS",
                                 @"YOUNG\nGIRLS"
                                 ];
    
    NSArray* allOptions = [@[hairOptions, makeUpOptions, careOptions, /*eventsOptions,*/ childrenOptions] valueForKeyPath: @"@unionOfArrays.self"];
    
    _dataSource = @[
                    @{@"name": @"HAIR", @"pic": [UIImage imageNamed:@"CategoryImage_Hair"], @"options": hairOptions},
                    @{@"name": @"MAKE UP", @"pic": [UIImage imageNamed:@"CategoryImage_Makeup"], @"options": makeUpOptions},
                    @{@"name": @"CARE", @"pic": [UIImage imageNamed:@"CategoryImages_Care"], @"options": careOptions},
                    @{@"name": @"EVENTS", @"pic": [UIImage imageNamed:@"CategoryImage_Events"], @"options": eventsOptions},
                    @{@"name": @"CHILDREN", @"pic": [UIImage imageNamed:@"CategoryImage_Children"], @"options": childrenOptions},
                    @{@"name": @"ALL", @"pic": [UIImage imageNamed:@"CategoryImage_All"], @"options": allOptions}
                    ];
}

@end
