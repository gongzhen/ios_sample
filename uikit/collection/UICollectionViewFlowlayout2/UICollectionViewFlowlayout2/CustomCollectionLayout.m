//
//  CustomCollectionLayout.m
//  UICollectionViewFlowlayout2
//
//  Created by zhen gong on 4/26/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "CustomCollectionLayout.h"


#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"

NSString *const CollectionElementKindSectionHeader = @"CollectionElementKindSectionHeader";
NSString *const CollectionElementKindSectionFooter = @"CollectionElementKindSectionFooter";

@interface CustomCollectionLayout()

@end

@implementation CustomCollectionLayout

#pragma mark - Public Accessors

- (void)prepareLayout {

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    return cell;
}

@end
