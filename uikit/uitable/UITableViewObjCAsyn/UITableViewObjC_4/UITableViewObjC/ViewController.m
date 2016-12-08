//
//  ViewController.m
//  UITableViewObjC
//
//  Created by gongzhen on 11/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "ViewController.h"

#pragma mark - TestCell

@interface GlitchModel : NSObject

@end

@implementation GlitchModel

- (NSString *)textForIndexPath:(NSIndexPath *)indexPath {
    [NSThread sleepForTimeInterval:0.1];
    return [NSString stringWithFormat:@"section: %ld row: %ld", (long)indexPath.section, (long)indexPath.row];
}

- (UIImage *)imageDownloadFromUrl:(NSString *)url {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    return image;
}

@end

@interface SerialOperationQueue: NSOperationQueue

@end

@implementation SerialOperationQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setMaxConcurrentOperationCount:1];
    }
    return self;
}

@end

@interface TestCell : UITableViewCell

@property (nonatomic, strong) UITextView *textFieldView;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, strong) SerialOperationQueue *queue;

// imageDownload Task
@property (nonatomic, strong) NSURLSessionDataTask *imageDownloadTask;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end

@implementation TestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textFieldView];
        [self.contentView addSubview:self.textImageView];
        self.queue = [[SerialOperationQueue alloc] init];
        [self setupLayoutConstraint];
    }
    return self;
}

- (UITextView *)textFieldView {
    if (_textFieldView == nil) {
        _textFieldView = [[UITextView alloc] initWithFrame:CGRectZero];
        [_textFieldView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_textFieldView setBackgroundColor:[UIColor blueColor]];
        [_textFieldView setUserInteractionEnabled:NO];
    }
    return _textFieldView;
}

- (UIImageView *)textImageView {
    if (_textImageView == nil) {
        _textImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_textImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_textImageView setBackgroundColor:[UIColor redColor]];
    }
    return _textImageView;
}

- (void) setupLayoutConstraint {
    // textField leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textFieldView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:10]];
    // textField topping
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textFieldView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10]];
    // textField bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textFieldView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:10]];
    // textField width
    [self.textFieldView addConstraint:[NSLayoutConstraint constraintWithItem:self.textFieldView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:100]];
    // imageView leading
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textImageView
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.textFieldView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:10]];
    // imageView trailing
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.textImageView
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:10]];

    // imageView top
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textImageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10]];
    // imageView bottom
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.textImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:10]];
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textFieldView.text = @"";
}

@end

@interface ViewController () {
    GlitchModel *_model;
    NSArray *_urlList;
    //dynamic tablecell height array
    NSMutableArray * _imageHeightsArray;
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;

//
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic, strong) NSURLSession *session;

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
        [_bottomView setBackgroundColor: [UIColor yellowColor]];
        [_bottomView setTranslatesAutoresizingMaskIntoConstraints: NO];
    }
    return _bottomView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[GlitchModel alloc] init];
    _urlList = [NSArray arrayWithObjects:@"http://i.imgur.com/UvqEgCv.png", @"http://i.imgur.com/dZ5wRtb.png", @"http://i.imgur.com/tPzTg7A.jpg", nil];
    
    [self setDefaultHeights];
    self.sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:self.sessionConfig];
    [self setLayoutConstraint];
    [self.tableView registerClass:[TestCell class] forCellReuseIdentifier:@"testcell"];
    [self.tableView reloadData];
}

- (void)setDefaultHeights {
    _imageHeightsArray = [NSMutableArray arrayWithCapacity:_urlList.count];
    for (int i = 0; i < [_urlList count]; i++) {
        NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:10];
        for (int j = 0; j < 10; j++) {
            [rows insertObject:@(self.tableView.rowHeight) atIndex:j];
        }
        [_imageHeightsArray insertObject:rows atIndex:i];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark uitableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_urlList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testcell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            if (cell == nil) {
                cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
            }
            [self configureCell:cell atIndexPath:indexPath];
            break;
        case 1:
            if (cell == nil) {
                cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
            }
            [self configureCell:cell atIndexPath:indexPath];
            break;
        case 2:
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

// http://stackoverflow.com/questions/15668160/asynchronous-downloading-of-images-for-uitableview-with-gcd
- (void)configureCell:(TestCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (cell.imageDownloadTask) {
        [cell.imageDownloadTask cancel];
    }
    
    cell.textImageView.image = nil;
    
    NSUInteger randomIndex = arc4random() % [_urlList count];
    NSURL *imageURL = [NSURL URLWithString:[_urlList objectAtIndex:randomIndex]];
    if (imageURL) {
        cell.imageDownloadTask = [self.session dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"ERROR: %@", error);
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.textFieldView.text = [_model textForIndexPath:indexPath];
                        cell.textImageView.image = image;
                        NSInteger oldHeight = [[_imageHeightsArray[indexPath.section] objectAtIndex:indexPath.row] integerValue];
                        NSInteger newHeight = image.size.height;
                        if (image.size.width > CGRectGetWidth(cell.textImageView.bounds)) {
                            CGFloat ratio = image.size.height / image.size.width;
                            newHeight = CGRectGetWidth(self.view.bounds) * ratio;
                        }
                        
                        if (oldHeight != newHeight) {
                            NSMutableArray *rows = [_imageHeightsArray objectAtIndex:indexPath.section];
                            [rows setObject:@(newHeight) atIndexedSubscript:indexPath.row];
                            [self.tableView beginUpdates];
                            [self.tableView endUpdates];
                        }
                    });
                } else {
                    NSLog(@"Couldn't load image at ULR:%@", imageURL);
                    NSLog(@"HTTP %ld", (long)httpResponse.statusCode);
                }
            }
        }];
        [cell.imageDownloadTask resume];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[[_imageHeightsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
}

- (void)setLayoutConstraint {
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    
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
                                                              constant:100.f]];
    
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
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}

@end
