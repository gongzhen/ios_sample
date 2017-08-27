//
//  ServiceViewModel.m
//  MVVMTableView1
//
//  Created by zhen gong on 8/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ServiceViewModel.h"
#import "ServiceModel.h"

static NSString *proSerivceTableViewIdentifier = @"ProServiceTableViewCellIdentifier";

@interface ServiceViewModel()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ServiceModel* model;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ServiceViewModel

- (ServiceModel *)model {
    if(_model == nil) {
        _model = [[ServiceModel alloc] init];
    }
    return _model;
}

- (instancetype)init {
    if(self = [super init]) {
        _dataSource = self.model.dataSource;
    }
    return self;
}

#pragma mark - uitableviewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *selectedRows = [tableView indexPathsForSelectedRows];
    if (selectedRows && [selectedRows containsObject:indexPath]) {
        NSDictionary* options = [_dataSource objectAtIndex:indexPath.section];
        NSArray* optionArray = [options valueForKey:@"options"];
        NSUInteger _ocount = optionArray.count;
        if (_ocount % 2 != 0) {
            _ocount++;
        }
        return ((_ocount/2) * 60.0f) + 120.0f;
    }
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.bounds.size.height > 120.0f) {
        [tableView beginUpdates];
        [tableView deselectRowAtIndexPath: indexPath animated: YES];
        [tableView endUpdates];
        return;
    }
    NSDictionary* options = [_dataSource objectAtIndex:indexPath.section];
    NSArray* optionArray = [options valueForKey:@"options"];
    __block NSUInteger acc = 1;
    [optionArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderColor = [[UIColor whiteColor] CGColor];
        btn.layer.borderWidth = 1.0f;
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGRect btnRect;
        CGFloat padding = 10.f;
        CGFloat yOffset = 128.f * acc + padding;
        if(idx % 2 == 0) {
            if(idx == optionArray.count - 1) {
                btnRect = CGRectMake(cell.contentView.bounds.size.width / 2 - (102 / 2), yOffset, 102, 108);
            } else {
                btnRect = CGRectMake(cell.contentView.bounds.size.width / 2 - 122, yOffset, 102, 108);
            }
        } else {
            btnRect = CGRectMake(cell.contentView.bounds.size.width / 2 + 20, yOffset, 102, 108);
            btn.enabled = NO;
        }
        btn.frame = btnRect;
        [cell.contentView addSubview:btn];
    }];
    [tableView beginUpdates];
    [tableView endUpdates];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:proSerivceTableViewIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:proSerivceTableViewIdentifier];
    }
    NSDictionary *dict = [_dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dict valueForKey:@"name"]];
    return  cell;
}

@end
