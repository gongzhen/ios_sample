//
//  ViewController.m
//  ColletionViewCellNestedTableView
//
//  Created by zhen gong on 7/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionViewCell.h"
#import "CustomTableViewCell.h"
#import "Constant.h"

const NSInteger PAGES = 6;

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,CustomTableViewCellDelegate> {
    CGRect tableCellRect;
    NSInteger mHeight;
}

@property (strong, nonatomic) UICollectionView *collectionView;

// Page 1: Hair stylist

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray* dataSource;
@property (strong, nonatomic) UIView* superView;
@property (strong, nonatomic) NSMutableSet *selectedVibes;

@end

@implementation ViewController

-(UIView *)superView:(CGRect)rect {
    if(_superView == nil) {
        mHeight = self.view.bounds.size.width < 400 ? 3 : 4;
        _superView = [[UIView alloc] initWithFrame: rect];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, K_TITLE_BANNER_MULTI_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - K_HAMBURGER_BANNER_HEIGHT - K_TITLE_BANNER_SINGLE_HEIGHT)];
        _tableView.backgroundColor = K_COLOR_BLACK;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        
        tableCellRect = CGRectMake(0, 0, self.view.bounds.size.width, 100);
        [_superView addSubview:_tableView];
    }
    return _superView;
}

- (void)loadView {
    [super loadView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    // Set up the collection view with no scrollbars, paging enabled
    // and the delegate and data source set to this view controller
    
    CGRect rect = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _selectedVibes = [[NSMutableSet alloc] init];
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
    
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return PAGES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue a prototype cell and set the label to indicate the page
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"Page %ld", indexPath.item + 1];
    
    // To provide a good view of pages, set each one to a different color
    CGFloat hue = (CGFloat)indexPath.item / PAGES;
    cell.backgroundColor = [UIColor colorWithHue:hue saturation:1.0f brightness:0.5f alpha:1.0f];
    
    [cell.contentView addSubview:[self superView:cell.contentView.bounds]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return _dataSource.count;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// the cell will be returned to the tableView
- (CustomTableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @autoreleasepool {
        static NSString *cellIdentifier = @"services";
        
        // Similar to UITableViewCell, but
        CustomTableViewCell *cell = (CustomTableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.delegate = self;
            cell.backgroundColor = K_COLOR_CLEAR;
            cell.contentView.backgroundColor = K_COLOR_CLEAR;
            [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
        }
        
        NSDictionary* obj = [_dataSource objectAtIndex:indexPath.section];
        
        [cell updateWithFrame:tableCellRect title:[obj valueForKey:@"name"] image:[obj valueForKey:@"pic"] options:[obj valueForKey:@"options"] andIndexPath:indexPath];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *selectedRows = [tableView indexPathsForSelectedRows];
    @autoreleasepool {
        if (selectedRows && [selectedRows containsObject:indexPath]) {
            // height is defined by the number of options,
            // and the option button size
            
            NSDictionary* o = [_dataSource objectAtIndex:indexPath.section];
            NSArray* _o = [o valueForKey:@"options"];
            NSUInteger _ocount = _o.count;
            if (_ocount % 2 != 0) {
                _ocount++;
            }
            return ((_ocount/2) * 128.0f) + 148.0f;
        }
    }
    // minimum height has a static or dynamic value
    // Henry may ask to change height depending on device type
    // also when iPad is added to the mix
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        // remove options of all expanded cells
        [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof CustomTableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj doRemoveOptions];
        }];
        CustomTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.bounds.size.height > 120.0f) {
            [self.tableView beginUpdates];
            [self.tableView deselectRowAtIndexPath: indexPath animated: YES];
            [self.tableView endUpdates];
            return;
        }
        [cell doShowOptions];
        [self updateTableView];
        if (indexPath.section >= mHeight) {
            // shift tv up 128px
            CGPoint p = self.view.center;
            p.x = 0;
            [tableView setContentOffset:p animated:YES];
        }
    }
}

- (void)updateTableView
{
    @autoreleasepool {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma ServiceTableViewCellDelegate
- (void)didSelectOption:(NSString *)option {
    NSLog(@"option:%@", option);
    if ([_selectedVibes containsObject:option]) {
        return;
    }
    
    [_selectedVibes addObject:option];
    
    NSLog(@"didSelectOption:");
    [_selectedVibes enumerateObjectsUsingBlock:^(__kindof NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"selected: %@", obj);
    }];
}

- (void)didRemoveOption:(NSString *)option {
    [_selectedVibes removeObject:option];
    
    NSLog(@"didRemoveOption:");
    [_selectedVibes enumerateObjectsUsingBlock:^(__kindof NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"selected: %@", obj);
    }];
}
@end
