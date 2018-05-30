//
//  ProListViewModel.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "ProListViewModel.h"
#import "Webservice.h"
#import "ProAvatarDownloader.h"
#import "ProModel.h"
#import "Constants.h"
#import "ProServicesTableViewCell.h"

/// static NSString *const TopPaidAppsFeed = @"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";
/// https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119301&lng=-118.256236
/// users?query=HAIRCUT&lat=34.119302&lng=-118.256236
static NSString *const TopPaidAppsFeed = @"https://dev.mobilestyles.com/users?query=HAIRCUT&lat=34.119302&lng=-118.256236";

@interface ProListViewModel()

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property(strong, nonatomic) Webservice* webService;

@end

@implementation ProListViewModel

- (instancetype)initWithService:(Webservice *)webService {
    if(self = [super init]) {
        self.webService = webService;
        _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)getProListFromUrl:(NSString *)url success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure {
    [self.webService get:url success:^(NSArray *results) {
        success(results);
    } failire:^(NSError *error) {
        failure(error);
    }];
}

- (void)startIconDownload:(ProModel *)model forIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    ProAvatarDownloader *downloader = [_imageDownloadsInProgress objectForKey:indexPath];
    DLog(@"index:%@ => downloader:%@ model.avarTarImage:%@", @(indexPath.row), downloader, model.avatarImage);
    if(downloader == nil) {
        downloader = [[ProAvatarDownloader alloc] init];
        downloader.avatarImage = model.avatarImage;
        __weak __typeof(ProAvatarDownloader *)weakSelf = downloader;
        [downloader setCompletionHandler:^{
            model.avatarImage = weakSelf.avatarImage;
            ProServicesTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = model.avatarImage;
            DLog(@"index:%ld model:%@", indexPath.row, model.avatarImage);
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            DLog(@"index:%@ => downloader:%@", @(indexPath.row), [self.imageDownloadsInProgress objectForKey:indexPath]);
        }];
        [self.imageDownloadsInProgress setObject:downloader forKey:indexPath];
        [downloader startDownload:model.avatarURL webService:self.webService];
    }
}

- (void)removeAllObjectsFromDownloadsInProgress {
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

@end
