//
//  GarageViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 3/8/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GarageViewController.h"

@interface GarageViewController ()

@end

@implementation GarageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


#pragma mark - Collection view delegate

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake([SystemUtils adjustSize:160], [SystemUtils adjustSize:176]);
//}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [[UICollectionViewCell alloc] init];
    return cell;
}

@end
