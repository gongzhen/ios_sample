//
//  SecondViewController.m
//  EasyTableGZ_OBJC
//
//  Created by gongzhen on 11/19/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "SecondViewController.h"
#import "UITableView+GZEasyTable.h"

@interface Test2Cell : UITableViewCell

@property (nonatomic, strong) UILabel *sizeLabel;

@end

@implementation Test2Cell

- (UILabel *)sizeLabel {
    if (_sizeLabel == nil) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.contentView.bounds.size.height)];
        [_sizeLabel setBackgroundColor:[UIColor redColor]];
        [_sizeLabel setNumberOfLines:0];
    }
    return _sizeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.sizeLabel];
        
        [self.sizeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.sizeLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.0 constant:18.f]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.sizeLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0 constant:9.f]];
        
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.sizeLabel
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.contentView
                                                                            attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0 constant:9.f];
        bottomConstraint.priority = 998;
        [self.contentView addConstraint: bottomConstraint];
        
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.sizeLabel
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1.0 constant:18.f];
        
        trailingConstraint.priority = 998;
        [self.contentView addConstraint: trailingConstraint];
        self.sizeLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 36;
    }
    return self;
}

@end

@interface SecondViewController ()

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SecondViewController

#pragma mark - lazy loading tableView
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        [_tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
        Test2Cell *cell = [[Test2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        // registerAutolayoutCell
        [_tableView registAutolayoutCell:cell forAutomaticCalculationHeightIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLayoutConstraint];
    [self initializeDataSource];
}

- (void)setLayoutConstraint {
    [self.view addSubview:self.tableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}

- (void)initializeDataSource {
    [self.tableView.tableModel addRowsWithModels:@[@"a", @"aaaaaaaaaaaa"] inSection:0];
    [self.tableView.tableModel addRowsWithModels:@[@"aa", @"aaaaaaaaaaaa"] inSection:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableView.tableModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableView.tableModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [_tableView intrinsicHeightAtIndexPath:indexPath
                                              forIdentifier:@"cell"
                                            configCellBlock:^(Test2Cell *cell, NSString *model) {
                                            }];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    Test2Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[Test2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *text = [tableView.tableModel modelAtIndexPath:indexPath];
    cell.sizeLabel.text = text;
    [cell setNeedsLayout];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {    
    return @"哈哈";
}



@end




