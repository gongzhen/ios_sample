//
//  ViewController.m
//  UICollectionViewFlowlayout1
//
//  Created by gongzhen on 4/10/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"

@interface ViewController ()


@end

#pragma mark - Accessors

@implementation ViewController

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat picDimension = self.view.frame.size.width / 4.0f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat leftRightInset = self.view.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
}

#pragma mark - private helper method

- (UIColor *)randomColor {
    int red = arc4random_uniform(255);
    int blue = arc4random_uniform(255);
    int green = arc4random_uniform(255);
    return [UIColor colorWithRed:red / 255.f green:green / 255.f blue:blue / 255.f alpha:1.0];
}

@end
