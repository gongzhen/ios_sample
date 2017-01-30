//
//  SDWebImageDownloader.h
//  UITableViewObjC_5
//
//  Created by gongzhen on 1/5/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDWebImageDownloader : NSObject

typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

@end
