//
//  ImageDownloader.m
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "ImageDownloader.h"
#import "PhotoRecord.h"
#import "NetworkManager.h"
#import <UIKit/UIKit.h>

@interface ImageDownloader()

@end

@implementation ImageDownloader

-(instancetype)initWithRecord:(PhotoRecord *)record{
    if(self = [super init]) {
        _photoRecord = record;
    }
    return self;
}

- (void)main {
    if(self.isCancelled || _photoRecord == nil) {
        return;
    }
    
    [[NetworkManager sharedInstance] fetchPhotoDataFromURL:_photoRecord.url success:^(NSData *data) {
        if(self.isCancelled) {
            return;
        }
        _photoRecord.image = [UIImage imageWithData:data];
    } failure:^(NSError *error) {
        _photoRecord.image = [UIImage imageNamed:@"Failed"];
    }];
    
}

@end
