//
//  ImageDownloader.h
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoRecord;

@interface ImageDownloader : NSOperation

@property(strong, nonatomic)PhotoRecord *photoRecord;

-(instancetype)initWithRecord:(PhotoRecord *)record;

@end
