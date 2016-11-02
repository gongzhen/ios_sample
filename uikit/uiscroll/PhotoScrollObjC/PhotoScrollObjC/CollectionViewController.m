//
//  CollectionViewController.m
//  PhotoScrollObjC
//
//  Created by gongzhen on 10/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "CollectionViewController.h"
#import "PhotoConst.h"
#import "PhotoCell.h"
#import "UIImage+Thumbnail.h"
#import "ManagePageViewController.h"

// class extension
@interface CollectionViewController()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    // Define private variables in @implementation.
    @private
    CGFloat _thumbnaiSize;
    UIEdgeInsets _sectionInsets;
    NSArray *_photos;
}
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CollectionViewController

#pragma mark - lazy loading
-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.minimumInteritemSpacing = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:collectionViewLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.bounces = YES;
        collectionView.alwaysBounceHorizontal = YES;
        collectionView.alwaysBounceVertical = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark life cycle.
-(void)viewDidLoad {
    [super viewDidLoad];
    
    _thumbnaiSize = 70;
    _sectionInsets = UIEdgeInsetsMake(10, 5.0, 10, 5.0);
    
    [self setupPhotosDataSource];
    [self setupNavigationItem];
    [self setupCollectionView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark setup array data source
-(void)setupPhotosDataSource {
    NSMutableArray *mutablePhotos = [NSMutableArray array];
    for (int i = 0; i <= 5; i++) {
        [mutablePhotos addObject: [NSString stringWithFormat:@"photo%d", i]];
    }
    _photos = [NSArray arrayWithArray: mutablePhotos];
}

#pragma mark - setup navigation item
-(void)setupNavigationItem {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"photo0"]];
    self.navigationItem.titleView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 87, 24);
}

#pragma mark setup UICollectionView
-(void)setupCollectionView {
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier: kReuseIdentifierCollectionViewCell];
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kReuseIdentifierCollectionViewCell forIndexPath: indexPath];
    UIImage *fullSizedImage = [UIImage imageNamed: [_photos objectAtIndex: indexPath.row]];
    cell.imageView.image = [fullSizedImage thumbnailOfSize: _thumbnaiSize];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ManagePageViewController *managePageViewController = [[ManagePageViewController alloc] init];
    managePageViewController.photos = _photos;
    managePageViewController.currentIndex = indexPath.row;
    [self.navigationController pushViewController:managePageViewController animated:YES];
    // [self presentViewController: managePageViewController animated:YES completion:^{
    // }];
}

#pragma mark UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_thumbnaiSize, _thumbnaiSize);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return _sectionInsets;
}


@end
