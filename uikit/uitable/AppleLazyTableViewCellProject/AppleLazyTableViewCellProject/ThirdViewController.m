//
//  ThirdViewController.m
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 6/27/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ThirdViewController.h"
#import "Webservice.h"
#import "ProListViewModel.h"
#import "ProServicesTableViewCell.h"
#import "ProAvatarDownloader.h"
#import "ProModel.h"
#import "FPSLabel.h"
#import "Constants.h"
#import "UIView+Add.h"
#import "Masonry.h"
#import "AFCollectionViewCell.h"
#import "HorizontalCollectionView.h"
#import "VerticalCollectionView.h"

@interface ThirdViewController ()

@property(strong, nonatomic) Webservice* webService;
@property(strong, nonatomic) ProListViewModel* proListViewModel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *hCollectionViewLayout;
@property (strong, nonatomic) UICollectionViewFlowLayout *vCollectionViewLayout;
@property (strong, nonatomic) HorizontalCollectionView *hCollectionView;
@property (strong, nonatomic) VerticalCollectionView *vCollectionView;

@end

static NSString *const TopPaidAppsFeed = @"/users?query=HAIRCUT&lat=34.129302&lng=-118.356236";
static NSString *const TopPaidAppsFeed2 = @"/users?query=HAIRCUT&lat=34.329302&lng=-118.256236";
static NSString *const proCollectionViewIdentifier = @"proServicesCollectionViewCellIdentifier";
static NSString *const kAvatarURL = @"avatar";
static NSString *const kFirstName = @"firstName";
static NSString *const kTitle = @"title";
static NSString *const kDistance = @"distance";
static NSString *const kAvailability = @"availability";
static NSString *const kRating = @"rating";
static NSString *const kPricing = @"pricing";
static NSString *const kDollars = @"dollars";

@implementation ThirdViewController {
    NSArray<ProModel *> *_hProDataSource;
    NSArray<ProModel *> *_vProDataSource;
}

#pragma mark - properties

-(HorizontalCollectionView *)hCollectionView {
    if (_hCollectionView == nil) {
        _hCollectionView = [[HorizontalCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) collectionViewLayout:self.hCollectionViewLayout];
        _hCollectionView.backgroundColor = UIColor.whiteColor;
    }
    return _hCollectionView;
}

-(VerticalCollectionView *)vCollectionView {
    if (_vCollectionView == nil) {
        _vCollectionView = [[VerticalCollectionView alloc] initWithFrame:CGRectMake(0, self.hCollectionView.frame.size.height + 10, self.view.frame.size.width, self.view.frame.size.height - self.hCollectionView.frame.size.height) collectionViewLayout:self.vCollectionViewLayout];
        _vCollectionView.backgroundColor = UIColor.whiteColor;
    }
    return _vCollectionView;
}

- (UICollectionViewFlowLayout *)hCollectionViewLayout {
    if(_hCollectionViewLayout == nil) {
        _hCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _hCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _hCollectionViewLayout.minimumLineSpacing = 0;
        _hCollectionViewLayout.minimumInteritemSpacing = 0;
    }
    return _hCollectionViewLayout;
}

- (UICollectionViewFlowLayout *)vCollectionViewLayout {
    if(_vCollectionViewLayout == nil) {
        _vCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        _vCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _vCollectionViewLayout.minimumLineSpacing = 0;
        _vCollectionViewLayout.minimumInteritemSpacing = 0;
    }
    return _vCollectionViewLayout;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.webService = [[Webservice alloc] init];
    self.proListViewModel = [[ProListViewModel alloc] initWithService:self.webService];
    // Do any additional setup after loading the view.
    // [self.view addSubview:self.collectionView];
    [self.view addSubview:self.hCollectionView];
    UIView *speratorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    speratorView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:speratorView];
    CGFloat offSet = self.hCollectionView.frame.size.height;
    speratorView.frame = CGRectMake(0, offSet, self.view.frame.size.width, 5);
    [self.view addSubview:self.vCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.proListViewModel getProListFromUrl:TopPaidAppsFeed success:^(NSArray *array) {
            /// DLog(@"array:%@", array);
            [strongSelf initHorizontalDataSource:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hCollectionView.proDataSource = [self->_hProDataSource copy];
                self.hCollectionView.numberOfItems = self->_hProDataSource.count;
                self.hCollectionView.sections = 1;
                [strongSelf.hCollectionView reloadData];
            });
        } failure:^(NSError *error) {
            
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.proListViewModel getProListFromUrl:TopPaidAppsFeed2 success:^(NSArray *array) {
            /// DLog(@"array:%@", array);
            [strongSelf initVerticalDataSource:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.vCollectionView.proDataSource = [self->_vProDataSource copy];
                self.vCollectionView.numberOfItems = self->_vProDataSource.count;
                self.vCollectionView.sections = 1;
                [strongSelf.vCollectionView reloadData];
            });
        } failure:^(NSError *error) {
            
        }];
    });
}

- (void)initVerticalDataSource:(NSArray *)array {
    __block NSMutableArray<ProModel *> *tempList = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProModel *model = [[ProModel alloc] init];
        NSDictionary *dict = (NSDictionary *)obj;
        
        if([dict objectForKey:kAvatarURL]) {
            model.avatarURL = [dict objectForKey:kAvatarURL];
        }
        if([dict objectForKey:kFirstName]) {
            model.name = [dict objectForKey:kFirstName];
        }
        if([dict objectForKey:kTitle]) {
            model.title = [dict objectForKey:kTitle];
        }
        if([dict objectForKey:kDistance]) {
            model.distance = [dict objectForKey:kDistance];
        }
        if([dict objectForKey:kAvailability]) {
            model.availability = [dict objectForKey:kAvailability];
        }
        if([dict objectForKey:kRating]) {
            model.rating = [dict objectForKey:kRating];
        }
        if([dict objectForKey:kPricing]) {
            model.pricing = [dict objectForKey:kPricing];
        }
        if([dict objectForKey:kDollars]) {
            model.dollars = [dict objectForKey:kDollars];
        }
        [tempList addObject:model];
    }];
    _vProDataSource = [tempList copy];
}

- (void)initHorizontalDataSource:(NSArray *)array {
    __block NSMutableArray<ProModel *> *tempList = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ProModel *model = [[ProModel alloc] init];
        NSDictionary *dict = (NSDictionary *)obj;
        
        if([dict objectForKey:kAvatarURL]) {
            model.avatarURL = [dict objectForKey:kAvatarURL];
        }
        if([dict objectForKey:kFirstName]) {
            model.name = [dict objectForKey:kFirstName];
        }
        if([dict objectForKey:kTitle]) {
            model.title = [dict objectForKey:kTitle];
        }
        if([dict objectForKey:kDistance]) {
            model.distance = [dict objectForKey:kDistance];
        }
        if([dict objectForKey:kAvailability]) {
            model.availability = [dict objectForKey:kAvailability];
        }
        if([dict objectForKey:kRating]) {
            model.rating = [dict objectForKey:kRating];
        }
        if([dict objectForKey:kPricing]) {
            model.pricing = [dict objectForKey:kPricing];
        }
        if([dict objectForKey:kDollars]) {
            model.dollars = [dict objectForKey:kDollars];
        }
        [tempList addObject:model];
    }];
    _hProDataSource = [tempList copy];
}

- (void)dealloc {
    DLog(@"Dealloc is called");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self configureCollectionViewLayoutItemSize];
}

- (void)configureCollectionViewLayoutItemSize {
    CGFloat inset = 10.f;
    self.hCollectionViewLayout.sectionInset = UIEdgeInsetsMake(inset, 0, inset, 0); /// top, left, bottom, right
    self.hCollectionViewLayout.itemSize = CGSizeMake(self.view.frame.size.width / 4, 80);
    
    self.vCollectionViewLayout.sectionInset = UIEdgeInsetsMake(inset, 0, inset, 0); /// top, left, bottom, right
    self.vCollectionViewLayout.itemSize = CGSizeMake(self.view.frame.size.width / 4, 120);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
