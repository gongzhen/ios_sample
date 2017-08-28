//
//  ViewController.m
//  NSOperationObjC
//
//  Created by Admin  on 8/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//  Asynchronous image loading in fast scrolling table cells
//  http://cocoanuts.mobi/2014/04/27/fastscroll/

#import "ViewController.h"
#import "NetworkManager.h"
#import "UIImageLoader.h"
#import "UIImageView+UIImageLoader.h"

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
//    _imageLoader.memoryCache.maxBytes = 50 * (1024 * 1024); //50MB
//    _imageLoader.cacheImagesInMemory = TRUE;
//    [_imageLoader setMemoryCacheMaxBytes:50 * 1024 * 1024 ];
//    [_imageLoader clearCachedFilesModifiedOlderThan1Week];
    [_imageLoader setUseServerCachePolicy:NO];
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
    cell.imageView.image = [UIImage imageNamed:@"dribbble_ball"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView uiImageLoader_setCancelsRunningTask:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* rowKey = (NSString *)[_photos.allKeys objectAtIndex:indexPath.row];
    NSURL* imageURL = [NSURL URLWithString:[_photos valueForKey:rowKey]];
    //    [cell.imageView uiImageLoader_setCancelsRunningTask:false];
    //    [cell.imageView uiImageLoader_setFinalContentMode:UIViewContentModeScaleAspectFit];
    //    [cell.imageView uiImageLoader_setImageWithURL:imageURL];
    //    [cell.imageView uiImageLoader_setImageWithURL:imageURL];
    
    [_imageLoader loadImageWithURL:imageURL hasCache:^(UIImage * _Nullable image, UIImageLoadSource loadedFromSource) {
//        DLog(@"rowKey:%@=>image:%@", rowKey, image);
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%ld is cached.", rowKey, indexPath.row];
        cell.imageView.image = image;
    } sendingRequest:^(BOOL didHaveCachedImage) {
//        DLog(@"didHaveCachedImage:%dl", didHaveCachedImage);
    } requestCompleted:^(NSError * _Nullable error, UIImage * _Nullable image, UIImageLoadSource loadedFromSource) {
        if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
//            DLog(@"image:%@", image);
            cell.textLabel.text = [NSString stringWithFormat:@"%@:%ld is downloaded", rowKey, indexPath.row];
            cell.imageView.image = image;
        }
    }];
}


@end
