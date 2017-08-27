//
//  ProServiceTableView.m
//  MVVMTableView1
//
//  Created by zhen gong on 8/7/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ProServiceTableView.h"
#import "ServiceViewModel.h"
#import <UIKit/UIKit.h>

static NSString *proSerivceTableViewIdentifier = @"ProServiceTableViewCellIdentifier";

@interface ProServiceTableView()

@property(nonatomic, strong) ServiceViewModel *viewModel;
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation ProServiceTableView

#pragma mark - property

-(UITableView *)tableView:(CGRect)withRect {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:withRect style:UITableViewStylePlain];
        _tableView.dataSource = self.viewModel;
        _tableView.delegate = self.viewModel;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:proSerivceTableViewIdentifier];
    }
    return _tableView;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:[self tableView:frame]];
    }
    return self;
}

- (ServiceViewModel *)viewModel {
    if(_viewModel == nil) {
        _viewModel = [[ServiceViewModel alloc] init];
    }
    return _viewModel;
}

@end
