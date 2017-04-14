//
//  ViewController.m
//  UICollectionViewFlowlayout1
//
//  Created by gongzhen on 4/10/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionLayout.h"

#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CustomCollectionViewLayoutDelegate>

@property(strong, nonatomic)NSMutableArray *itemHeights;

@end

#pragma mark - Accessors

@implementation ViewController

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        CustomCollectionLayout *layout = [[CustomCollectionLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemHeights = [[NSMutableArray alloc] init];
    for(int i = 0; i < CELL_COUNT; i++) {
        CGFloat itemHeight = arc4random_uniform(100) + 1;
        [_itemHeights addObject:@(itemHeight)];
    }
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Life cycle

- (void)dealloc {
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [label setText:[NSString stringWithFormat:@"%ld:%ld", (long)indexPath.section, (long)indexPath.row]];
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark - private helper method

- (UIColor *)randomColor {
    int red = arc4random_uniform(255);
    int blue = arc4random_uniform(255);
    int green = arc4random_uniform(255);
    return [UIColor colorWithRed:red / 255.f green:green / 255.f blue:blue / 255.f alpha:1.0];
}

#pragma mark - CustomCollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomCollectionLayout *)layout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / 2 - 3 * 10, [[_itemHeights objectAtIndex:indexPath.row] floatValue]);
}

@end
