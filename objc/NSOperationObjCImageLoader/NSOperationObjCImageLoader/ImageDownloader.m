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

    if(self.isCancelled) {
        return;
    }
    

//    NSData *data = [NSData dataWithContentsOfURL:_photoRecord.url];
//    if(data == nil || data.length == 0) {
//        _photoRecord.image = [UIImage imageNamed:@"Failed"];
//        _photoRecord.state = PhotoRecordStateFailed;
//        return;
//    }
//    _photoRecord.image = [UIImage imageWithData:data];
//    _photoRecord.state = PhotoRecordStateDownloaded;

    if([self.name isEqualToString:@"Volcan y saltos"]) {
        DLog(@"self.name:%@ state:%ld", self.name, (long)self.photoRecord.state);
        DLog(@"self.name:%@ url:%@", self.name, self.photoRecord.url);
    }
    
    [[NetworkManager sharedInstance] fetchPhotoDataFromURL:_photoRecord.url success:^(NSData *data) {
        if(self.isCancelled) {
            data = nil;
            return;
        }
        self.photoRecord.image = [UIImage imageWithData:data];
        self.photoRecord.state = PhotoRecordStateDownloaded;
        DLog(@"_photoRecord:%@ is successful.", self.photoRecord.name);
    } failure:^(NSError *error) {
        self.photoRecord.image = [UIImage imageNamed:@"Failed"];
        self.photoRecord.state = PhotoRecordStateFailed;
        DLog(@"_photoRecord:%@ is failed.", self.photoRecord.name);
    }];
    
}

@end
