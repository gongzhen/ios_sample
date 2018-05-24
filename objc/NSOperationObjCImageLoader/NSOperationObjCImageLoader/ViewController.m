//
//  ViewController.m
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//  https://github.com/gngrwzrd/UIImageLoader
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
            self.photos = [tempArray copy];
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = [NSArray array];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell.accessoryView == nil) {
        cell.accessoryView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return cell;
}
    
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoRecord* photoDetails = _photos[indexPath.row];
//    if([photoDetails.name isEqualToString:@"Volcan y saltos"]) {
//        DLog(@"photoDetails name:%@ state:%ld", photoDetails.name, (long)photoDetails.state);
//    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@%ld", photoDetails.name, (long)indexPath.row];
    cell.imageView.image = photoDetails.image;
    
    switch (photoDetails.state) {
        case PhotoRecordStateNew:
        case PhotoRecordStateDownloaded:
            // isDragging: returns YES if user has started scrolling.
            // returns YES if user isn't dragging (touch up) but scroll view is still moving
//            if([photoDetails.name isEqualToString:@"Volcan y saltos"]) {
//                DLog(@"isDragging:%d,isDecelerating:%d", tableView.isDragging, tableView.isDecelerating);
//            }
            if (!tableView.dragging && !tableView.decelerating){
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
//    if([photoRecord.name isEqualToString:@"Volcan y saltos"]) {
//        DLog(@"photoRecord name:%@ state:%ld", photoRecord.name, (long)photoRecord.state);
//    }
    switch (photoRecord.state) {
        case PhotoRecordStateNew:
            [self startDownloadForRecord:photoRecord indexPath:indexPath];
            break;
        case PhotoRecordStateDownloaded:
            break;
        default:
            DLog(@"photoRecord name:%@%ld state:%ld", photoRecord.name,(long)indexPath, (long)photoRecord.state);
            NSLog(@"do nothing");
            break;
    }
}

- (void)startDownloadForRecord:(PhotoRecord *)photoRecord indexPath:(NSIndexPath *)indexPath {
    // Check for the particular indexPath to see if there is already an operation.
    DLog(@"_pendingOperation[indexPath:%ld]:%@", indexPath.row, [_pendingOperation.downloadsInProgress objectForKey:indexPath]);
    if([_pendingOperation.downloadsInProgress objectForKey:indexPath] != nil) {
        return;
    }

    ImageDownloader* downloader = [[ImageDownloader alloc] initWithRecord:photoRecord];
    __weak ImageDownloader* weakDownloader = downloader;

    downloader.completionBlock = ^{
//        if([weakDownloader.photoRecord.name isEqualToString:@"Volcan y saltos"]) {
//            DLog(@"downloader:%@ is fisnih:. %d, status:%ld", weakDownloader.name, weakDownloader.isFinished, (long)weakDownloader.photoRecord.state);
//        }
        
        if(weakDownloader.isCancelled) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pendingOperation.downloadsInProgress removeObjectForKey:indexPath];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        });
    };
    
    [_pendingOperation.downloadsInProgress setObject:downloader forKey:indexPath];
    [_pendingOperation.downloadQueue addOperation:downloader];
    [_pendingOperation updateMapWithKey:downloader.name];
    DLog(@"_pendingOperation.map:%@ add:%@", _pendingOperation.map, downloader.name);
    DLog(@"_pendingOperation.operations:%@",_pendingOperation.downloadQueue.operations);
    DLog(@"_pendingOperation.downloadsInProgress:%@ indexPath:%ld",downloader.name, (long)indexPath.row);
    
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
    NSSet* visibleRows = [NSSet setWithArray:pathsArray];
    if(visibleRows == nil || visibleRows.count <= 0) {
        return;
    }
    
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:_pendingOperation.downloadsInProgress.allKeys];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    [toBeStarted minusSet:pendingOperations];
    
    [toBeCancelled minusSet:visibleRows];
    
//    DLog(@"toBeStarted:%@", toBeStarted);
//    DLog(@"toBeCancelled:%@", toBeCancelled);
    
    for(NSIndexPath *indexPath in toBeCancelled) {
        ImageDownloader* pendingDownload = [_pendingOperation.downloadsInProgress objectForKey:indexPath];
        if(pendingDownload) {
            [pendingDownload cancel];
            [_pendingOperation.downloadsInProgress removeObjectForKey:indexPath];
        }
    }
    toBeCancelled = nil;
    
    for(NSIndexPath *indexPath in toBeStarted) {
        PhotoRecord *recordToProcess = [_photos objectAtIndex:indexPath.row];
        if(recordToProcess) {
//            DLog(@"recordToProcess:%@, status:%ld, indexPath:%ld", recordToProcess.name, (long)recordToProcess.state, (long)indexPath.row);
            [self startOperationsForPhotoRecord:recordToProcess indexPath:indexPath];
        }
    }
    toBeStarted = nil;
}

- (void)resumeAllOperations {
    [_pendingOperation.downloadQueue setSuspended:NO];
}



@end
