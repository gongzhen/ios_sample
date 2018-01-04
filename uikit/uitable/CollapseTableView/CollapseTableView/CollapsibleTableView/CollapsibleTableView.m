//
//  CollapsibleTableView.m
//  CollapseTableView
//
//  Created by Zhen Gong on 12/15/17.
//  Copyright © 2017 Zhen Gong. All rights reserved.
//

#import "CollapsibleTableView.h"
#import "CollapsibleTableCell.h"
#import "TableSection.h"
#import "CollapsibleTableViewHeader.h"

static const CGFloat TABLE_HEADER_HEIGHT = 55;
static const CGFloat TABLE_CELL_HEIGHT = 50;
static NSString *serivceOfferTableViewIdentifier = @"ServiceOfferTableViewCellIdentifier";

@interface CollapsibleTableView() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray<TableSection *>* sectionData;
@property (copy, nonatomic) NSArray* selectedIndex;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableSet* tableViewCells;

@end

@implementation CollapsibleTableView

#pragma mark - Properties

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        // _tableView.backgroundColor = K_COLOR_BLACK;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[CollapsibleTableCell class] forCellReuseIdentifier:serivceOfferTableViewIdentifier];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame sectionData:(NSArray *)sectionData{
    if(self = [super initWithFrame:frame]) {
        _sectionData = [sectionData copy];
        _tableViewCells = [NSMutableSet set];
        // self.backgroundColor = K_COLOR_LIGHT_GRAY;
        CGRect tableRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.tableView.frame = tableRect;
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_sectionData[section].collapsed) {
        return 0;
    } else {
        return _sectionData[section].sectionItems.count;
    }
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CollapsibleTableCell *cell;
    cell = (CollapsibleTableCell *)[tableView dequeueReusableCellWithIdentifier:serivceOfferTableViewIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CollapsibleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serivceOfferTableViewIdentifier];
    }
    cell.tag = indexPath.row;
    [self.tableViewCells addObject:cell];
    // cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(CollapsibleTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if([self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
//        return [self.delegate tableViewHeightForHeaderInSection:section];
//    }
    return TABLE_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_CELL_HEIGHT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CollapsibleTableViewHeader *header = (CollapsibleTableViewHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if(header == nil) {
        header = [[CollapsibleTableViewHeader alloc] initWithReuseIdentifier:@"header"];
    }
    [header updateHeader:self.sectionData[section].sectionName];
    header.headerButton.tag = section;
    // header.delegate = self;
    [header setCollapsed:self.sectionData[section].collapsed];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}


@end
