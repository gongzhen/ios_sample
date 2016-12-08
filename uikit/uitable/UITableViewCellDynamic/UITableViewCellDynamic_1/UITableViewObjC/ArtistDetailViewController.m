//
//  ArtistDetailViewController.m
//  UITableViewCellDynamic_1
//
//  Created by gongzhen on 12/6/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ArtistDetailViewController.h"
#import "UIColor+Hex.h"
#import "UILabel+GZUILabelExtension.h"
#import "UIView+GZUIViewExtension.h"
#import "Work.h"

@interface WorkTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *workImageView;
@property (nonatomic, strong) UILabel *workTitleLabel;
@property (nonatomic, strong) UITextView *moreInfoTextView;

@end

@implementation WorkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.workImageView];
        [self.contentView addSubview:self.workTitleLabel];
        [self.contentView addSubview:self.moreInfoTextView];
        [self setupLayoutConstraint];
    }
    return self;
}

- (UIImageView *)workImageView {
    if (_workImageView == nil) {
        _workImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_workImageView setBackgroundColor:[UIColor blueColor]];
        [_workImageView setUserInteractionEnabled:NO];
        // UILayoutConstraintAxisHorizontal
        [_workImageView setContentHuggingPriority:251.0f forAxis:UILayoutConstraintAxisHorizontal];
        [_workImageView setContentHuggingPriority:252.0f forAxis:UILayoutConstraintAxisVertical];
        [_workImageView setContentCompressionResistancePriority:750.0f forAxis:UILayoutConstraintAxisHorizontal];
        [_workImageView setContentCompressionResistancePriority:749.0f forAxis:UILayoutConstraintAxisVertical];
        [_workImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [_workImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return _workImageView;
}

- (UILabel *)workTitleLabel {
    if (_workTitleLabel == nil) {
        UIColor* bioTextColor = [UIColor colorWithWhite:114/255.0f alpha:1.0];
        _workTitleLabel = [UILabel labelWithBackgroundColor:[UIColor clearColor]
                                                  textColor:bioTextColor
                                              textAlighment:NSTextAlignmentLeft
                                              numberOFLines:0
                                                       text:@""
                                                   fontSize:12];
        [_workTitleLabel setUserInteractionEnabled:NO];
        [_workTitleLabel setContentHuggingPriority:251.0f forAxis:UILayoutConstraintAxisHorizontal];
        [_workTitleLabel setContentHuggingPriority:252.0f forAxis:UILayoutConstraintAxisVertical];
        [_workTitleLabel setContentCompressionResistancePriority:750.0f forAxis:UILayoutConstraintAxisHorizontal];
        [_workTitleLabel setContentCompressionResistancePriority:749.0f forAxis:UILayoutConstraintAxisVertical];
        [_workTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_workTitleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }
    return _workTitleLabel;
}

- (UITextView *)moreInfoTextView {
    if (_moreInfoTextView == nil) {
        _moreInfoTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        [_moreInfoTextView setMultipleTouchEnabled:YES];
        [_moreInfoTextView setUserInteractionEnabled:NO];
        [_moreInfoTextView setContentMode:UIViewContentModeScaleToFill];
        
        // textView set to yes, then textView disappear.
        // textView has to set to NO.
        [_moreInfoTextView setScrollEnabled:NO];
        [_moreInfoTextView setText:@"Select For More Info."];
        [_moreInfoTextView setTextAlignment:NSTextAlignmentCenter];
        [_moreInfoTextView setBackgroundColor:[UIColor redColor]];
        [_moreInfoTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _moreInfoTextView;
}

- (void) setupLayoutConstraint {
    
    // workImageView topping
    // <constraint firstItem="self.workImageView" firstAttribute="top" secondItem="self.contentView" secondAttribute="topMargin" id="Ug8-00-Dfm"/>
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.workImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // workImageView leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.workImageView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                multiplier:1.0
                                                                  constant:8.0]];
    // workImageView trailing
    //  <constraint firstItem="self.contentView" firstAttribute="trailingMargin" secondItem="workImageView" secondAttribute="trailing" constant="8" id="H2J-0G-xw7"/>
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.workImageView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:8.0]];

    // workTitleLabel top to workImageView bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.workTitleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.workImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // workTitleLabel width
    //  <constraint firstItem="self.workTitleLabel" firstAttribute="width" secondItem="self.workImageView" secondAttribute="width" id="FEv-Yx-Bpu"/>
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.workTitleLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.workImageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // workTitleLabel centerX with contentView
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.workTitleLabel
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0]];
    
    // moreInfoTextView top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.moreInfoTextView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.workTitleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // moreInfoTextView leading
    //  <constraint firstItem="moreInfoTextView" firstAttribute="leading" secondItem="self.contentView" secondAttribute="leadingMargin" constant="8" id="45y-Vf-aVT"/>

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.moreInfoTextView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                multiplier:1.0
                                                                  constant:8.0]];
    
    // moreInfoTextView trailing
    // <constraint firstItem="self.contentView" firstAttribute="trailingMargin" secondItem="self.moreInfoTextView" secondAttribute="trailing" constant="8" id="4bu-Ta-vgE"/>
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.moreInfoTextView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:8.0]];
    
    // moreInfoTextView bottomMargin
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.moreInfoTextView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottomMargin
                                                                multiplier:1.0
                                                                  constant:0]];
}

@end

@interface ArtistDetailViewController() {
    NSString *_moreIntoText;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ArtistDetailViewController

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        [_topView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_topView setBackgroundColor:[UIColor colorWithHex:0x0D60FA]];
        [_topView setAlpha:1.0];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_bottomView setBackgroundColor:[UIColor colorWithHex:0x0D60AA]];
        [_bottomView setAlpha:1.0];
    }
    return _bottomView;
}

#pragma mark - lazy loading tableView
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        [_tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    return _tableView;
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.tableView];
    [self setLayoutConstraint];
    _moreIntoText = @"Select For More Info >";
    self.title = _selectedArtist.name;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerClass:[WorkTableViewCell class] forCellReuseIdentifier:@"kWorkTableViewCell"];
    [self.tableView reloadData];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _selectedArtist.works.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kWorkTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kWorkTableViewCell"];
    }
    
    Work *work = [_selectedArtist.works objectAtIndex:indexPath.row];
    cell.workTitleLabel.text = work.title;
    cell.workImageView.image = work.image;
    
    cell.workTitleLabel.backgroundColor = [UIColor colorWithWhite:204 / 255.f alpha:1.0f];
    cell.workTitleLabel.textAlignment = NSTextAlignmentCenter;
    cell.moreInfoTextView.textColor = [UIColor colorWithWhite:114 / 255.0f alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.moreInfoTextView.text = work.isExpanded ? work.info : _moreIntoText;
    cell.moreInfoTextView.textAlignment = work.isExpanded ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    
    return cell;
}


#pragma mark - uitableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1
    WorkTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        return;
    }
    
    Work *work = [_selectedArtist.works objectAtIndex:indexPath.row];
    
    // 2
    work.isExpanded = !work.isExpanded;
    [_selectedArtist.works setObject:work atIndexedSubscript:indexPath.row];
    
    // 3
    cell.moreInfoTextView.text = work.isExpanded ? work.info : _moreIntoText;
    cell.moreInfoTextView.textAlignment = work.isExpanded ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    
    // 4
    [tableView beginUpdates];
    [tableView endUpdates];
    
    // 5
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}


#pragma mark - setup layout constraint

- (void)setLayoutConstraint {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    // topView top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeTopMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topView
                                                          attribute:NSLayoutAttributeTopMargin
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // topView leading
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // topView trailing
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // topView height
    [self.topView addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:200.f]];
    
    // bottomView bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeBottomMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottomMargin
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // bottomView leading
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // bottomView trailing
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1.0
                                                           constant:0.f]];
    
    // bottomView height
    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:55.f]];
    
    // tableView top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    // tableView trailing
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    // tableView leading
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    // tableView bottom
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
}

@end
