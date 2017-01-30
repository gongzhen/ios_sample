//
//  PodcastFeedTableViewController.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "PodcastFeedTableViewController.h"
#import "PodcastStore.h"
#import "PersistanceManager.h"
#import "PodcastItemCell.h"
#import "UIView+AutoLayoutHelper.h"

@interface PodcastFeedTableViewController()

@property (nonatomic, strong) UITableView *tableView;

@end

NSString *const kIdentifierOfPodcastItemCell = @"PodcastItemCell";

@implementation PodcastFeedTableViewController

#pragma mark - lazy loading

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 75;
        [_tableView registerClass:[PodcastItemCell class] forCellReuseIdentifier:kIdentifierOfPodcastItemCell];
    }
    return _tableView;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"pattern-grey"];
    
    [self.view addSubview:self.tableView];
    [self setupViewConstraint];
    
    if (patternImage) {
        UIView *backgroundView = [[UIView alloc] init];
        [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
        [_tableView setBackgroundView:backgroundView];
    }
    
    if ([PodcastStore sharedManager].items.count == 0){
        NSLog(@"Loading podcast feed for the first time");
        [[PodcastStore sharedManager] refreshItems:^(bool didLoadNewItems) {
            if (didLoadNewItems == YES) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    }
}

- (void)setupViewConstraint {
    [self.tableView addTopConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView addLeftConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView addRightConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.tableView addBottomConstraintToView:self.tableView.superview relation:NSLayoutRelationEqual constant:0.f];
}


#pragma mark - uitableviewdatasource, uitableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%lu", [PodcastStore sharedManager].items.count)
    return [PodcastStore sharedManager].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PodcastItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierOfPodcastItemCell];
    if (cell == nil) {
        cell = [[PodcastItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifierOfPodcastItemCell];
    }
    [cell updateWithPodcastItem:[[PodcastStore sharedManager].items objectAtIndex:indexPath.row]];
    return cell;
}


@end
