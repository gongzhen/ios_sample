//
//  ViewController.m
//  UITableViewObjC
//
//  Created by gongzhen on 11/28/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//  http://www.thomashanning.com/the-most-common-mistake-in-using-uitableview/
//  http://techqa.info/programming/question/23599161/Strange-Reorder-Cell-animation-glitch

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

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, strong) SerialOperationQueue *queue;

@end

@implementation TestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.textImageView];
        self.queue = [[SerialOperationQueue alloc] init];
    }
    return self;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, self.contentView.frame.size.height)];
        [_textField setBackgroundColor:[UIColor blueColor]];
        [_textField setUserInteractionEnabled:NO];
    }
    return _textField;
}

- (UIImageView *)textImageView {
    if (_textImageView == nil) {
        _textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 210, self.contentView.frame.size.height)];
        [_textImageView setBackgroundColor:[UIColor redColor]];
        [_textImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _textImageView;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[GlitchModel alloc] init];
    _urlList = [NSArray arrayWithObjects:@"http://i.imgur.com/UvqEgCv.png", @"http://i.imgur.com/dZ5wRtb.png", @"http://i.imgur.com/tPzTg7A.jpg", nil];
//
//    http://stackoverflow.com/questions/8113268/how-to-cancel-nsblockoperation
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    NSBlockOperation *op = [[NSBlockOperation alloc] init];
//    __weak NSBlockOperation *weakOp = op;
//    [op addExecutionBlock:^{
//        if ([weakOp isCancelled]) {
//            return;
//        }
//        NSLog(@"addExecutionBlock");
//    }];
//    [queue addOperation:op];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
            if (cell == nil) {
                cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"testcell"];
            if (cell == nil) {
                cell = [[TestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
            }
            break;
        default:
            break;
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[TestCell class]] == YES) {
        [((TestCell *)cell).queue cancelAllOperations];
        
        NSBlockOperation *operation = [[NSBlockOperation alloc] init];
        
        __weak NSBlockOperation * weakOperation = operation;
        [operation addExecutionBlock:^{
            NSString *text = [_model textForIndexPath:indexPath];
            
            NSUInteger randomIndex = arc4random() % [_urlList count];
            UIImage *image = [_model imageDownloadFromUrl:[_urlList objectAtIndex:randomIndex]];
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                if ([weakOperation isCancelled] == YES) {
                    return;
                }
                ((TestCell *)cell).textField.text = text;
                ((TestCell *)cell).textImageView.image = image;
            });
        }];
        
        [((TestCell *)cell).queue addOperation:operation];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            [self configureCell:cell atIndexPath:indexPath];
            break;
        case 1:
            [self configureCell:cell atIndexPath:indexPath];
            break;
        default:
            break;
    }
    
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
