//
//  ProAvatarDownloader.h
//  AppleLazyTableViewCellProject
//
//  Created by Zhen Gong on 5/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Webservice;

@interface ProAvatarDownloader : NSObject

@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload:(NSString *)urlString webService:(Webservice *)webService;
- (void)cancelDownload;

@end
