//
//  PinterestViewController.m
//  CustomPinterestCollectionView
//
//  Created by Zhen Gong on 9/30/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

#import "PinterestViewController.h"
#import "AnnotatedPhotoCell.h"
#import "PinterestLayout.h"
#import "Photos.h"

@interface PinterestViewController ()<PinterestLayoutDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) PinterestLayout *pinterestLayout;
@property (copy, nonatomic) NSArray<Photo *> *photos;

@end

@implementation PinterestViewController

- (PinterestLayout *)pinterestLayout {
    if (!_pinterestLayout) {
        _pinterestLayout = [[PinterestLayout alloc] init];
    }
    return _pinterestLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.pinterestLayout];
        _collectionView.backgroundColor = UIColor.clearColor;
        [_collectionView registerClass:[AnnotatedPhotoCell class] forCellWithReuseIdentifier:@"identifier"];
        _collectionView.contentInset = UIEdgeInsetsMake(23, 10, 10, 10);
        _collectionView.dataSource = self;
        self.pinterestLayout.delegate = self;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"Pattern"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [self.view addSubview:self.collectionView];
    self.photos = [Photos allPhotos];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForPhotoAtIndexPath:(NSIndexPath *)indexPath {
    return [self.photos objectAtIndex:indexPath.item].image.size.height;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnnotatedPhotoCell *cell = (AnnotatedPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    Photo *photo = [self.photos objectAtIndex:indexPath.item];
    if (indexPath.item % 2 == 0) {
        cell.contentView.backgroundColor = UIColor.redColor;
    } else {
        cell.contentView.backgroundColor = UIColor.blueColor;
    }
    [cell configure:photo];
    return cell;
}

@end
