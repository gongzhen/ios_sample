//
//  GarageViewController.m
//  CaknowGZ
//
//  Created by gongzhen on 3/8/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "GarageViewController.h"
#import "GetConsumerVehiclesEntity.h"
#import "GarageCell.h"
#import "CKUIKit.h"


const static int NUMBEROFCOLUMNS = 2;

@interface GarageViewController () {
//    NSMutableArray *_vehiclesDatasource;
}

@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, strong) UIImageView *bgImageView;

// About NSMutable - String / Dictionary
// http://stackoverflow.com/questions/4995254/nsmutablestring-as-retain-copy
@property (strong, nonatomic) NSMutableArray *vehiclesDatasource;

@end

@implementation GarageViewController

#pragma mark - lazy load collectionView

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [CKUIKit generateImageViewWithBackgroundColor:[UIColor whiteColor]];
        _bgImageView.image = [UIImage imageNamed:kBackgroundMain];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GarageCell class] forCellWithReuseIdentifier:@"GarageCell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GARAGE";
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.collectionView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupLayoutConstraint];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:kColorMain]
                                                  forBarMetrics:UIBarMetricsDefault];
    UIButton *leftMenuButton = [CKUIKit generateNormalButtonWithTitle:@"" titleColor:nil backgroundImage:[UIImage imageNamed:kButtonNavigationMenu]];
    leftMenuButton.frame = CGRectMake(0, 0, 71, 30);
    // [dismissButton addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftMenuItem = [[UIBarButtonItem alloc] initWithCustomView:leftMenuButton];
    self.navigationItem.rightBarButtonItem = leftMenuItem;
    
    UIButton *addCarButton = [CKUIKit generateNormalButtonWithTitle:@"" titleColor:nil backgroundImage:[UIImage imageNamed:kPlusWhilt]];
    addCarButton.frame = CGRectMake(0, 0, 71, 30);
    // [dismissButton addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addCarItem = [[UIBarButtonItem alloc] initWithCustomView:addCarButton];
    self.navigationItem.rightBarButtonItem = addCarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _vehiclesDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GarageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GarageCell" forIndexPath:indexPath];
    cell.vehicleEntity = [_vehiclesDatasource objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout method

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = _collectionView.contentInset;
    CGFloat contentWidth = _collectionView.bounds.size.width - (insets.left + insets.right);
    CGFloat columnWidth = contentWidth / NUMBEROFCOLUMNS - 20;
    return CGSizeMake(columnWidth, columnWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//}

#pragma mark - ui layout constraint

- (void)setupLayoutConstraint {
    __weak typeof(self) weakSelf = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_topLayoutGuide);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0.f);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0.f);
        make.bottom.equalTo(weakSelf.mas_bottomLayoutGuide);
    }];
}

#pragma mark - Helper method

- (void)refreshData {
    [[HttpRequestManager sharedInstance] read:@"consumer/vehicles"
                                   parameters:nil
                                      success:^(id resultObj) {
                                          GetConsumerVehiclesEntity *consumerVehiclesEntity = resultObj;
                                          DLog(@"%@", resultObj);
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              _vehiclesDatasource = consumerVehiclesEntity.vehicles;
                                              [_collectionView reloadData];
                                          });
                                      } failure:^(NSError *error) {
                                          DLog(@"%@", error);
                                      }];


}

@end
