//
//  ViewController.m
//  UITableViewObjC
//
//  Created by gongzhen on 11/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutoLayoutHelper.h"

#pragma mark - TestCell

@interface GlitchModel : NSObject

@end

@implementation GlitchModel

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath {
    [NSThread sleepForTimeInterval:1];
    return [NSString stringWithFormat:@"section: %ld row: %ld", (long)indexPath.section, (long)indexPath.row];
}

- (UIImage *)imageDownloadFromUrl:(NSString *)url {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    return image;
}

@end

@interface TestCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *textImageView;

@end

@implementation TestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textImageView];
        [self setupCellConstraint];
    }
    return self;
}

- (void)layoutSubviews {
    DLog(@"%@", NSStringFromCGSize(self.textImageView.frame.size));
    self.textImageView.layer.cornerRadius = self.textImageView.frame.size.width / 2;
    self.textImageView.layer.masksToBounds = YES;
}

- (void)setupCellConstraint {
    [self.textImageView addTopConstraintToView:self.textImageView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.textImageView addBottomConstraintToView:self.textImageView.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.textImageView addLeftConstraintToView:self.textField attribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual constant:0.f];
    [self.textImageView addTrailingConstraintToView:self.textImageView.superview relation:NSLayoutRelationEqual constant:0.f];
    
    [self.textField addTopConstraintToView:self.textField.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.textField addLeftConstraintToView:self.textField.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.textField addBottomConstraintToView:self.textField.superview relation:NSLayoutRelationEqual constant:0.f];
    [self.textField addWidthConstraintWithRelation:NSLayoutRelationEqual constant:200.f];
}

- (UIImageView *)textImageView {
    if (_textImageView == nil) {
        _textImageView = [[UIImageView alloc] init];
        [_textImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_textImageView setBackgroundColor:[UIColor redColor]];
        [_textImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _textImageView;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        [_textField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_textField setBackgroundColor:[UIColor blueColor]];
        [_textField setUserInteractionEnabled:NO];
    }
    return _textField;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textField.text = @"";
}

@end

@interface ViewController () {
    GlitchModel *_model;
    NSArray *_urlList;
}

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *bottomView;

@end

@implementation ViewController

#pragma mark - lazy loading tableView
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        [_tableView setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    return _tableView;
}

-(UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        [_topView setBackgroundColor: [UIColor grayColor]];
        [_topView setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    return _topView;
}

-(UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottomView setBackgroundColor: [UIColor greenColor]];
        [_bottomView setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _urlList = @[@"http://i.imgur.com/UvqEgCv.png", @"http://i.imgur.com/dZ5wRtb.png", @"http://i.imgur.com/tPzTg7A.jpg"];
    _model = [[GlitchModel alloc] init];
    [self setLayoutConstraint];
    [self.tableView registerClass:[TestCell class] forCellReuseIdentifier:@"testcell1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
            if (cell == nil) {
                cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
            }
            [self configureCell:cell atIndexPath:indexPath];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
            if (cell == nil) {
                cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
            }
            [self configureCell:cell atIndexPath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TestCell class]] == YES) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSString *fieldText = [_model textForIndexPath:indexPath];
            NSUInteger randomIndex = arc4random() % [_urlList count];
            
            UIImage *image = [_model imageDownloadFromUrl: [_urlList objectAtIndex:randomIndex]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ((TestCell *)cell).textField.text = fieldText;
                ((TestCell *)cell).textImageView.image = image;
                [cell setNeedsLayout];
           });
        });
    }
}

- (void)setLayoutConstraint {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // topView top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.topLayoutGuide
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    // topView trailing
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    // topView leading
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0]];
    // topView height
    [self.topView addConstraint:[NSLayoutConstraint constraintWithItem:self.topView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:50.f]];
    // bottomView height
    [self.bottomView addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:50]];
    // bottomView leading
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.f]];
    // bottomView trailing
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.f]];
    // bottomView bottom
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.bottomView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.f]];
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
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    

    
    
    
    
}

@end
