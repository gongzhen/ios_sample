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

/// static NSString *const TopPaidAppsFeed = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";
/// https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119301&lng=-118.256236
/// users?query=HAIRCUT&lat=34.119302&lng=-118.256236
static NSString *const TopPaidAppsFeed = @"https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119302&lng=-118.256236";
static const CGFloat TABLE_HEADER_HEIGHT = 100;
static const CGFloat TABLE_CELL_HEIGHT = 64;
static NSString *tableViewIdentifier = @"tableViewIdentifierIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) Webservice* webService;
@property(strong, nonatomic) ProListViewModel* proListViewModel;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation ViewController

-(UITableView *)tableView:(CGRect)withRect {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:withRect style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ProServicesTableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
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
    NSURL *url = [NSURL URLWithString:TopPaidAppsFeed];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.proListViewModel getProListFromUrl:url success:^(NSArray *array) {
            DLog(@"proList:%@", array);
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier forIndexPath:indexPath];
    return cell;
}

@end
