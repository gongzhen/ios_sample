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
        self.name = record.name;
    }
    return self;
}

- (void)main {
    if([self.name isEqualToString:@"Cute Monkey"]) {
        DLog(@"self.name:%@ state:%ld", self.name, (long)self.photoRecord.state);
        DLog(@"self.name:%@ url:%@", self.name, self.photoRecord.url);
    }
    if(self.isCancelled) {
        return;
    }
    
//
//    NSData *data = [NSData dataWithContentsOfURL:_photoRecord.url];
//    if(data == nil || data.length == 0) {
//        _photoRecord.image = [UIImage imageNamed:@"Failed"];
//        _photoRecord.state = PhotoRecordStateFailed;
//        return;
//    }
//    _photoRecord.image = [UIImage imageWithData:data];
//    _photoRecord.state = PhotoRecordStateDownloaded;
    
    [[NetworkManager sharedInstance] fetchPhotoDataFromURL:_photoRecord.url success:^(NSData *data) {
        if(self.isCancelled) {
            return;
        }
        _photoRecord.image = [UIImage imageWithData:data];
        _photoRecord.state = PhotoRecordStateDownloaded;
        DLog(@"_photoRecord:%@ is successful.", _photoRecord.name);
    } failure:^(NSError *error) {
        _photoRecord.image = [UIImage imageNamed:@"Failed"];
        _photoRecord.state = PhotoRecordStateFailed;
        DLog(@"_photoRecord:%@ is failed.", _photoRecord.name);
    }];
    
}

@end
