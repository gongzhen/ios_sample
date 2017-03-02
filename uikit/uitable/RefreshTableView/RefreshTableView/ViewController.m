//
//  ViewController.m
//  RefreshTableView
//
//  Created by gongzhen on 2/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutoLayoutHelper.h"
#import "Loan.h"

#define kLatestLoanURL  [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/newest.json"]

NSString * const kIdentifierOfTableCell = @"kIdentifierOfTableCell";

@interface TableCell : UITableViewCell

@property (strong, nonatomic) UILabel *loanName;
@property (strong, nonatomic) UILabel *loanCountry;
@property (strong, nonatomic) UILabel *loanUse;
@property (strong, nonatomic) UILabel *loanAmount;

@end

@implementation TableCell

-(UILabel *)loanName {
    if (_loanName == nil) {
        _loanName = [[UILabel alloc] init];
        [_loanName setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _loanName;
}

-(UILabel *)loanCountry {
    if (_loanCountry == nil) {
        _loanCountry = [[UILabel alloc] init];
        [_loanCountry setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _loanCountry;
}

-(UILabel *)loanUse {
    if (_loanUse == nil) {
        _loanUse = [[UILabel alloc] init];
        [_loanUse setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _loanUse;
}

-(UILabel *)loanAmount {
    if (_loanAmount == nil) {
        _loanAmount = [[UILabel alloc] init];
        [_loanAmount setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _loanAmount;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.loanName];
        [self.contentView addSubview:self.loanAmount];        
        [self.contentView addSubview:self.loanCountry];
        [self.contentView addSubview:self.loanUse];

        [self setupConstraints];
    }
    return self;
}

-(void)setupConstraints {
    [self.loanName addLeftConstraintToView:self.loanName.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanName addTopConstraintToView:self.loanName.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanName addBottomConstraintToView:self.loanName.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanName addWidthConstraintWithRelation:NSLayoutRelationEqual constant:self.contentView.bounds.size.width / 4];
    
    [self.loanAmount addLeftConstraintToView:self.loanName attribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual constant:0.f];
    [self.loanAmount addTopConstraintToView:self.loanAmount.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanAmount addBottomConstraintToView:self.loanAmount.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanAmount addWidthConstraintWithRelation:NSLayoutRelationEqual constant:self.contentView.bounds.size.width / 4];
    
    [self.loanCountry addLeftConstraintToView:self.loanAmount attribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual constant:0.f];
    [self.loanCountry addTopConstraintToView:self.loanCountry.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanCountry addBottomConstraintToView:self.loanCountry.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanCountry addWidthConstraintWithRelation:NSLayoutRelationEqual constant:self.contentView.bounds.size.width / 4];

    [self.loanUse addLeftConstraintToView:self.loanCountry attribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual constant:0.f];
    [self.loanUse addTopConstraintToView:self.loanAmount.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanUse addBottomConstraintToView:self.loanAmount.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.loanUse addWidthConstraintWithRelation:NSLayoutRelationEqual constant:self.contentView.bounds.size.width / 4];
}

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_loans;
    UIRefreshControl *_refreshControl;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ViewController

-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;

    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    _refreshControl.backgroundColor = [UIColor purpleColor];
    [_refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = _refreshControl;

    [self.tableView addTopConstraintToView:self.topLayoutGuide attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView addLeftConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView addRightConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView addBottomConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView registerClass:[TableCell class] forCellReuseIdentifier:kIdentifierOfTableCell];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

- (void)handleRefresh {
    NSURLRequest *request = [NSURLRequest requestWithURL:kLatestLoanURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [_refreshControl endRefreshing];
            return;
        }
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                [_refreshControl endRefreshing];
                return;
            }
        }
        
        NSArray *latestLoans = [self fetchData:data];
        _loans = [NSMutableArray arrayWithCapacity:10];
        if (latestLoans) {
            for (NSDictionary *loanDic in latestLoans) {
                Loan *loan = [[Loan alloc] init];
                loan.name = [loanDic objectForKey:@"name"];
                loan.amount = [loanDic objectForKey:@"loan_amount"];
                loan.use = [loanDic objectForKey:@"use"];
                loan.country = [[loanDic objectForKey:@"location"] objectForKey:@"country"];
                [_loans insertObject:loan atIndex:0];
            }
        }
        
        // As this block of code is run in a background thread, we need to ensure the GUI
        // update is executed in the main thread
        [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    [task resume];
}

- (void)reloadData {
    // Reload table data
    [self.tableView reloadData];

    if (_refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        _refreshControl.attributedTitle = attributedTitle;
        [_refreshControl endRefreshing];
    }
}

- (NSArray *)fetchData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil) {
        return nil;
    }
    
    if ([parsedData objectForKey:@"loans"] == nil) {
        return nil;
    }
    
    NSArray *latestLoans = [parsedData objectForKey:@"loans"];
    return latestLoans;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_loans) {
        return [_loans count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOfTableCell forIndexPath:indexPath];
    
    // Configure the cell...
    Loan *loan = [_loans objectAtIndex:indexPath.row];
    cell.loanName.text = loan.name;
    cell.loanUse.text = loan.use;
    cell.loanCountry.text = loan.country;
    cell.loanAmount.text = [NSString stringWithFormat:@"$%@", [loan.amount stringValue]];
    return cell;
}

@end
