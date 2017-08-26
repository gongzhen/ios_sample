//
//  ViewController.m
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "UIImageLoader.h"

static NSString *const cellIdentifier = @"cellidentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary* photos;
@property (strong, nonatomic) UIImageLoader* imageLoader;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Classic Photos";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _imageLoader = [UIImageLoader sharedInstance];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [[NetworkManager sharedInstance] fetchPhotoURLDetails:^(NSDictionary *datasourceDictionary) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _photos = datasourceDictionary;
            [_tableView reloadData];
        });
    } failure:^(NSError *error) {
        _photos = [NSDictionary dictionary];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* rowKey = (NSString *)[_photos.allKeys objectAtIndex:indexPath.row];
    NSURL* imageURL = [NSURL URLWithString:[_photos valueForKey:rowKey]];
    // DLog(@"rowKey:%@=>imageURL:%@", rowKey, imageURL);
    [_imageLoader loadImageWithURL:imageURL hasCache:^(UIImage * _Nullable image, UIImageLoadSource loadedFromSource) {
        
    } sendingRequest:^(BOOL didHaveCachedImage) {
        
    } requestCompleted:^(NSError * _Nullable error, UIImage * _Nullable image, UIImageLoadSource loadedFromSource) {
        if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
            DLog(@"image:%@", image);
            cell.textLabel.text = rowKey;
            cell.imageView.image = image;
        }
    }];
}


@end
