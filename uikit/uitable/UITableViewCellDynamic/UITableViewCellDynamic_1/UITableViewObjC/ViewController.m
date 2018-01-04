//
//  ViewController.m
//  UITableViewObjC
//
//  Created by gongzhen on 11/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "Artist.h"
#import "UILabel+GZUILabelExtension.h"
#import "UIColor+Hex.h"
#import "ArtistDetailViewController.h"

@interface ArtistTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *bioLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *artistImageView;

@end

@implementation ArtistTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.bioLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.artistImageView];
        [self setupLayoutConstraint];
    }
    return self;
}

- (UILabel *)bioLabel {
    if (_bioLabel == nil) {
        UIColor* bioTextColor = [UIColor colorWithWhite:114/255.0f alpha:1.0];
        _bioLabel = [UILabel labelWithBackgroundColor:[UIColor clearColor]
                                            textColor:bioTextColor
                                        textAlighment:NSTextAlignmentLeft
                                        numberOFLines:0
                                                 text:@""
                                             fontSize:12];
        [_bioLabel setUserInteractionEnabled:NO];
        [_bioLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_bioLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }
    return _bioLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UIColor *nameLabelBackgroundColor = [UIColor colorWithRed:255 / 255.0 green:152 / 255.0 blue:0 / 255.0 alpha:1];
        _nameLabel = [UILabel labelWithBackgroundColor:nameLabelBackgroundColor
                                            textColor:[UIColor whiteColor]
                                        textAlighment:NSTextAlignmentCenter
                                        numberOFLines:0
                                                 text:@""
                                             fontSize:12];
        [_nameLabel setUserInteractionEnabled:NO];
        [_nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _nameLabel;
}

- (UIImageView *)artistImageView {
    if (_artistImageView == nil) {
        _artistImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_artistImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [_artistImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return _artistImageView;
}

- (void) setupLayoutConstraint {
    // nameLabel leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // nameLabel bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottomMargin
                                                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                    toItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // nameLabel height
    [self.nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:30]];
    
    // nameLabel width
    [self.nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:self.contentView.bounds.size.width / 2]];
    
    // artistImageView leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // artistImageView topping
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // artistImageView bottom and nameLable top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:8.0]];
    // artistImageView width
    [self.artistImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.artistImageView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:self.contentView.bounds.size.width / 2]];
    
    // bioLabel bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottomMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // bioLabel top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // bioLabel trailing
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:8]];
    
    // bioLabel leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:16]];
}

//- (void)prepareForReuse {
//    [super prepareForReuse];
//    // self.textFieldView.text = @"";
//    self.nameLabel.text = @"";
//    self.bioLabel.text = @"";
//}

@end

// new cell starts

@interface ArtistTableViewCell1 : UITableViewCell

@property (nonatomic, strong) UILabel *bioLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *artistImageView;

@end

@implementation ArtistTableViewCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.bioLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.artistImageView];
        [self setupLayoutConstraint];
    }
    return self;
}

- (UILabel *)bioLabel {
    if (_bioLabel == nil) {
        UIColor* bioTextColor = [UIColor colorWithWhite:114/255.0f alpha:1.0];
        _bioLabel = [UILabel labelWithBackgroundColor:[UIColor clearColor]
                                            textColor:bioTextColor
                                        textAlighment:NSTextAlignmentLeft
                                        numberOFLines:0
                                                 text:@""
                                             fontSize:12];
        [_bioLabel setUserInteractionEnabled:NO];
        [_bioLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_bioLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }
    return _bioLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        UIColor *nameLabelBackgroundColor = [UIColor colorWithRed:255 / 255.0 green:152 / 255.0 blue:0 / 255.0 alpha:1];
        _nameLabel = [UILabel labelWithBackgroundColor:nameLabelBackgroundColor
                                             textColor:[UIColor whiteColor]
                                         textAlighment:NSTextAlignmentCenter
                                         numberOFLines:0
                                                  text:@""
                                              fontSize:12];
        [_nameLabel setUserInteractionEnabled:NO];
        [_nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _nameLabel;
}

- (UIImageView *)artistImageView {
    if (_artistImageView == nil) {
        _artistImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_artistImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [_artistImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    return _artistImageView;
}

- (void) setupLayoutConstraint {
    // nameLabel leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // nameLabel bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottomMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeBottomMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // nameLabel height
    [self.nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:30]];
    
    // nameLabel width
    [self.nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:self.contentView.bounds.size.width / 2]];
    
    // artistImageView leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeadingMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // artistImageView topping
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTopMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    // artistImageView bottom and nameLable top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:8.0]];
    // artistImageView width
    [self.artistImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.artistImageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:self.contentView.bounds.size.width / 2]];
    
    // bioLabel bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // bioLabel top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // bioLabel trailing
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                multiplier:1.0
                                                                  constant:0]];
    
    // bioLabel leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.artistImageView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:16]];
}

//- (void)prepareForReuse {
//    [super prepareForReuse];
//    // self.textFieldView.text = @"";
//    self.nameLabel.text = @"";
//    self.bioLabel.text = @"";
//}

// new cell ends

@end

@interface ViewController() {
    NSMutableArray *_artists;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *collapseArray;

@end

@implementation ViewController

#pragma mark - lazy loading tableView
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        _tableView.backgroundView = nil;
        [_tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    return _tableView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        [_topView setTranslatesAutoresizingMaskIntoConstraints:NO];
        // [_topView setBackgroundColor:[UIColor colorWithHexString:@"0x0D60FA"]];
        [_topView setBackgroundColor:[UIColor colorWithHex:0x0D60FA]];
        [_topView setAlpha:1.0];
    }
    return _topView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        // [_topView setBackgroundColor:[UIColor colorWithHexString:@"0x0D60FA"]];
        [_bottomView setBackgroundColor:[UIColor colorWithHex:0x0D60AA]];
        [_bottomView setAlpha:1.0];
    }
    return _bottomView;
}

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _artists = [Artist artistsFromBundle];
    DLog(@"artists %@", _artists);
    _collapseArray = [NSMutableArray array];
    for(int i = 0; i < 2; i++) {
        [_collapseArray addObject:[NSNumber numberWithBool:YES]]; // default close
    }
    [self setLayoutConstraint];
    [self.tableView registerClass:[ArtistTableViewCell class] forCellReuseIdentifier:@"artistTableViewCell"];
    [self.tableView registerClass:[ArtistTableViewCell class] forCellReuseIdentifier:@"artistTableViewCell1"];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:140];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"tableView size %@", NSStringFromCGSize(self.tableView.bounds.size));
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:mainQueue  usingBlock:^(NSNotification * _Nonnull note) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([_collapseArray[section] boolValue] == YES) {
        return 0;
    } else {
        if(section == 0) {
            return 3;
        } else if (section == 1) {
            return 4;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistTableViewCell" forIndexPath:indexPath];
    
    Artist *artist;
    switch (indexPath.section) {
        case 0:
            if (cell == nil) {
                cell = [[ArtistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"artistTableViewCell"];
            }
            artist = _artists[indexPath.row];
            if (artist) {
                cell.bioLabel.text = artist.bio;
                cell.artistImageView.image = artist.image;
                cell.nameLabel.text = artist.name;
            }
            break;
        case 1:
            if (cell == nil) {
                cell = [[ArtistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"artistTableViewCell1"];
            }
            artist = _artists[indexPath.row + 3];
            if (artist) {
                cell.bioLabel.text = artist.bio;
                cell.artistImageView.image = artist.image;
                cell.nameLabel.text = artist.name;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 120.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 120.f)];
    headerView.backgroundColor = [UIColor colorWithHex:0x0D60AC];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.textColor = [UIColor blackColor];
    [label setText:[NSString stringWithFormat:@"Section %ld", (long)section]];
    label.font = [UIFont systemFontOfSize:12.0];
    [headerView addSubview:label];
    headerView.tag = section;
    label.tag = section;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
    [label addGestureRecognizer:gesture];
    return headerView;
}

- (void)labelTap:(UITapGestureRecognizer *)sender {
    if([(UITapGestureRecognizer *)sender view].tag == 0) {
        DLog(@"%d", [_collapseArray[0] boolValue]);
        _collapseArray[0] = [NSNumber numberWithBool:!([_collapseArray[0] boolValue])];
        DLog(@"%d", [_collapseArray[0] boolValue]);
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if([(UITapGestureRecognizer *)sender view].tag == 1) {
        DLog(@"%d", [_collapseArray[1] boolValue]);
        _collapseArray[1] = [NSNumber numberWithBool:!([_collapseArray[1] boolValue])];
        DLog(@"%d", [_collapseArray[1] boolValue]);
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
    artistDetailViewController.selectedArtist = [_artists objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

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
