//
//  HorizontalCollectionView.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/5/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "HorizontalCollectionView.h"
#import "ProServicesCollectionViewCell.h"
#import "ProModel.h"
#import "Webservice.h"

@interface HorizontalCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic) Webservice* webService;

@end

static NSString *const proCollectionViewIdentifier = @"proCollectionViewIdentifier";

@implementation HorizontalCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        self.webService = [[Webservice alloc] init];
        [self registerClass:[ProServicesCollectionViewCell class] forCellWithReuseIdentifier:proCollectionViewIdentifier];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProServicesCollectionViewCell *cell = (ProServicesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:proCollectionViewIdentifier forIndexPath:indexPath];
    ProModel *model = [_proDataSource objectAtIndex:indexPath.row];
    if(model.avatarImage != nil) {
        cell.avatarImage.image = model.avatarImage;
    } else {
        [cell configure:model webSerivce:self.webService completion:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ProServicesCollectionViewCell *cell = (ProServicesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                NSLog(@"index:%ld image:%@", indexPath.row, image);
                cell.avatarImage.image = image;
            });
        }];
        cell.avatarImage.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    
    return cell;
}

@end
