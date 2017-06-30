//
//  ViewController.m
//  SDWebImageGZ
//
//  Created by gongzhen on 1/8/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

static NSString * const cellIdentifier = @"cell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray* _dataSource;
}

@property(nonatomic, strong)UITableView *tableView;
    
@end

@implementation ViewController

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 140;
        _tableView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _tableView;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initDataSource];
    [self.view addSubview:self.tableView];
    [self setupLayoutConstraint];
}
    
- (void)setupLayoutConstraint {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_tableView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.f]];
}
    
- (void)initDataSource {
    _dataSource = @[@"https://s-media-cache-ak0.pinimg.com/564x/cc/a4/c9/cca4c94c8641258490ae5adb3d0edec2.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/29/b2/a0/29b2a00048b3a40d30ebf56ca5e98b86.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/63/31/f4/6331f427f48c2c5e7487373f8fdcf9de.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e4/7c/c2/e47cc2acfe289320a0acf0d5cca83ba4.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/24/a6/e6/24a6e69dcdd9c20ce4175131e4321134.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e5/a4/54/e5a454b3fdb87bf0b263b146c5f71bbb.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e8/56/49/e85649798c402c9240f25ccfaac895c3.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/75/53/b5/7553b58e063e12b46bfb72fee515562e.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/2e/3a/f1/2e3af145b1ed620cf6c75850dbc6ec6b.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/ab/99/26/ab992679d1ce38de393fd7a76507f65b.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/b0/c0/2c/b0c02c2c3d728743746aea6bd229121a.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e8/b5/79/e8b579e1c0cdc4d644643d41668356dd.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/originals/b2/5c/39/b25c39f73b27adb99721588fd4e34ab7.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/32/e2/41/32e2413585f1d2e0333c7dee3c4808bf.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/29/b2/a0/29b2a00048b3a40d30ebf56ca5e98b86.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/63/31/f4/6331f427f48c2c5e7487373f8fdcf9de.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e4/7c/c2/e47cc2acfe289320a0acf0d5cca83ba4.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/24/a6/e6/24a6e69dcdd9c20ce4175131e4321134.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e5/a4/54/e5a454b3fdb87bf0b263b146c5f71bbb.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e8/56/49/e85649798c402c9240f25ccfaac895c3.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/75/53/b5/7553b58e063e12b46bfb72fee515562e.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/2e/3a/f1/2e3af145b1ed620cf6c75850dbc6ec6b.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/ab/99/26/ab992679d1ce38de393fd7a76507f65b.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/b0/c0/2c/b0c02c2c3d728743746aea6bd229121a.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/564x/e8/b5/79/e8b579e1c0cdc4d644643d41668356dd.jpg",
                    @"https://s-media-cache-ak0.pinimg.com/originals/b2/5c/39/b25c39f73b27adb99721588fd4e34ab7.jpg"
                    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    static UIImage *placeHolder = nil;
    if(!placeHolder) {
        placeHolder = [UIImage imageNamed:@"placeholder"];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:[_dataSource objectAtIndex:indexPath.row]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error || !data) {
            // place hodler image
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.cellImageView.image = placeHolder;
            });
        } else if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.cellImageView.image = [UIImage imageWithData:data];
            });
        }
    }] resume];
    return cell;
}
    
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.f;
}

@end
