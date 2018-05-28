//
//  ViewController.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ViewController.h"
#import "Webservice.h"
#import "ProListViewModel.h"
#import "ProServicesTableViewCell.h"
#import "ProAvatarDownloader.h"
#import "ProModel.h"

/// static NSString *const TopPaidAppsFeed = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";
/// https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119301&lng=-118.256236
/// users?query=HAIRCUT&lat=34.119302&lng=-118.256236
static NSString *const TopPaidAppsFeed = @"/users?query=HAIRCUT&lat=34.129302&lng=-118.356236";
static const CGFloat TABLE_HEADER_HEIGHT = 100;
static const CGFloat TABLE_CELL_HEIGHT = 64;
static NSString *const proTableViewIdentifier = @"proServicesTableViewCellIdentifier";
static NSString *const kAvatarURL = @"avatar";
static NSString *const kFirstName = @"firstName";
static NSString *const kTitle = @"title";
static NSString *const kDistance = @"distance";
static NSString *const kAvailability = @"availability";
static NSString *const kRating = @"rating";
static NSString *const kPricing = @"pricing";
static NSString *const kDollars = @"dollars";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) Webservice* webService;
@property(strong, nonatomic) ProListViewModel* proListViewModel;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation ViewController {
    NSArray<ProModel *> *_proDataSource;
}

-(UITableView *)tableView:(CGRect)withRect {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:withRect style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = TABLE_CELL_HEIGHT;
        [_tableView registerClass:[ProServicesTableViewCell class] forCellReuseIdentifier:proTableViewIdentifier];
    }
    return _tableView;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:[self tableView:self.view.frame]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    self.webService = [[Webservice alloc] init];
    self.proListViewModel = [[ProListViewModel alloc] initWithService:self.webService];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.proListViewModel getProListFromUrl:TopPaidAppsFeed success:^(NSArray *array) {
            [strongSelf initDataSource:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        } failure:^(NSError *error) {
            
        }];
    });
}

- (void)initDataSource:(NSArray *)array {
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
    _proDataSource = [tempList copy];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self terminateAllDownloads];
}

- (void)terminateAllDownloads{
    [self.proListViewModel removeAllObjectsFromDownloadsInProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_CELL_HEIGHT;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return _proDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProServicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:proTableViewIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[ProServicesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:proTableViewIdentifier];
    }
    ProModel *model = [_proDataSource objectAtIndex:indexPath.row];
    [cell configure:model index:indexPath.row];
    DLog(@"index:%@ => image:%@", @(indexPath.row), model.avatarImage);
    if(model.avatarImage == nil) {
        if(self.tableView.isDragging == NO && self.tableView.decelerating == NO) {
            [self.proListViewModel startIconDownload:model forIndexPath:indexPath tableView:self.tableView];
        }
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    } else {
        cell.imageView.image = model.avatarImage;
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if(_proDataSource.count > 0) {
            NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
            for(NSIndexPath *indexPath in visiblePaths) {
                ProModel *model = [_proDataSource objectAtIndex:indexPath.row];
                ProServicesTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if(model.avatarImage == nil) {
                    [self.proListViewModel startIconDownload:model forIndexPath:indexPath tableView:self.tableView];
                    cell.imageView.image = model.avatarImage;
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(_proDataSource.count > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for(NSIndexPath *indexPath in visiblePaths) {
            ProModel *model = [_proDataSource objectAtIndex:indexPath.row];
            ProServicesTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if(model.avatarImage == nil) {
                [self.proListViewModel startIconDownload:model forIndexPath:indexPath tableView:self.tableView];
                cell.imageView.image = model.avatarImage;
            }
        }
    }
}

@end
