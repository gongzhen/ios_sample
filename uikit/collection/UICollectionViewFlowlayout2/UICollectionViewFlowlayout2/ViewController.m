//
//  ViewController.m
//  UICollectionViewFlowlayout2
//
//  Created by zhen gong on 4/26/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        CustomCollectionLayout *layout = [[CustomCollectionLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        // sectionInset
        // headerHeight
        // footerHeight
        // minimjmColumnSpacing
        // minimumInteritemSpacing
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return  _collectionView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

#pragma mark - 

- (CGSize)collectionView:(UICollectionView *)collectionView collectionViewLayout:(CustomCollectionLayout *)layout sizeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(0, 0);
}


@end
