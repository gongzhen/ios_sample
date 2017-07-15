//
//  CustomTableViewCell.h
//  TableViewNestedCollectionView1
//
//  Created by zhen gong on 7/11/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexedCollectionView.h"

// @class IndexedCollectionView;

static NSString *collectionViewCellIdentifier = @"collectionViewCell";

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) IndexedCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>) dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
