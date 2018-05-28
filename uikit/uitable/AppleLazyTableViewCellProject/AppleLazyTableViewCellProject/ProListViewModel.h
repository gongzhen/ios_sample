//
//  ProListViewModel.h
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Webservice;
@class ProModel;
@class ProServicesTableViewCell;

@interface ProListViewModel : NSObject

- (instancetype)initWithService:(Webservice *)webService;
- (void)getProListFromUrl:(NSString *)url success:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure;
- (void)startIconDownload:(ProModel *)model forIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (void)removeAllObjectsFromDownloadsInProgress;

@end
