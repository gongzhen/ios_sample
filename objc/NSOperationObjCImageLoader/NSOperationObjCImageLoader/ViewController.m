//
//  ViewController.m
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "PhotoRecord.h"
#import "ImageDownloader.h"
#import "PendingOperations.h"

static NSString *const cellIdentifier = @"cellidentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
    
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSArray* photos;
@property (strong, nonatomic) PendingOperations* pendingOperation;

@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Classic Photos";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSMutableArray *tempArray = [NSMutableArray array];
    _pendingOperation = [[PendingOperations alloc] init];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [[NetworkManager sharedInstance] fetchPhotoURLDetails:^(NSDictionary *datasourceDictionary) {
    
        for(NSString *key in datasourceDictionary) {
            NSString* urlString = [datasourceDictionary valueForKey:key];
            if(urlString) {
                NSURL *url = [NSURL URLWithString:urlString];
                PhotoRecord* photoRecord = [[PhotoRecord alloc] initWith:key url:url];
                [tempArray addObject:photoRecord];
            }
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            _photos = [tempArray copy];
            [_tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _photos = [NSArray array];        
        });
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
    PhotoRecord* photoDetails = _photos[indexPath.row];
    if(cell.accessoryView == nil) {
        cell.accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    cell.textLabel.text = photoDetails.name;
    cell.imageView.image = photoDetails.image;
    
    switch (photoDetails.state) {
        case PhotoRecordStateNew:
        case PhotoRecordStateDownloaded:
            if(!_tableView.isDragging && !_tableView.isDecelerating) {
                [self startOperationsForPhotoRecord:photoDetails indexPath:indexPath];
            }
            break;
        case PhotoRecordStateFailed:
            break;
        case PhotoRecordStateFiltered:
            break;
    }
}

- (void)startOperationsForPhotoRecord:(PhotoRecord *)photoRecord indexPath:(NSIndexPath *)indexPath {
    if([photoRecord.name isEqualToString:@"Cute Monkey"]) {
        DLog(@"photoRecord name:%@ state:%ld", photoRecord.name, (long)photoRecord.state);
    }
    switch (photoRecord.state) {
        case PhotoRecordStateNew:
            [self startDownloadForRecord:photoRecord indexPath:indexPath];
            break;
        case PhotoRecordStateDownloaded:
            break;
        default:
            break;
    }
}

- (void)startDownloadForRecord:(PhotoRecord *)photoRecord indexPath:(NSIndexPath *)indexPath {
    // Check for the particular indexPath to see if there is already an operation.
    if([_pendingOperation.downloadsInProgress objectForKey:indexPath] != nil) {
        return;
    }

    ImageDownloader* downloader = [[ImageDownloader alloc] initWithRecord:photoRecord];
    __weak ImageDownloader* weakDownloader = downloader;
    downloader.completionBlock = ^{
        if([weakDownloader.photoRecord.name isEqualToString:@"Cute Monkey"]) {
            DLog(@"downloader:%@ is fisnih:. %d, status:%ld", weakDownloader.name, weakDownloader.isFinished, (long)weakDownloader.photoRecord.state);
        }
        
        if(weakDownloader.isCancelled) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_pendingOperation.downloadsInProgress removeObjectForKey:indexPath];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
    };
    
    [_pendingOperation.downloadsInProgress setObject:downloader forKey:indexPath];
    [_pendingOperation.downloadQueue addOperation:downloader];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

- (void)suspendAllOperations {
    [_pendingOperation.downloadQueue setSuspended:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}

- (void)loadImagesForOnscreenCells {
    NSArray *pathsArray = [_tableView indexPathsForVisibleRows];
    if(pathsArray.count <= 0) {
        return;
    }
    
}

- (void)resumeAllOperations {
    _pendingOperation.downloadQueue.suspended = NO;
}



@end
