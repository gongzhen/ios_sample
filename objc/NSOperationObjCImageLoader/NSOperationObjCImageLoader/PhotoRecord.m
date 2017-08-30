//
//  PhotoRecord.m
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "PhotoRecord.h"

@implementation PhotoRecord

- (instancetype)initWith:(NSString *)name url:(NSURL *)url {
    if(self = [super init]) {
        _name = name;
        _url = url;
        _image = [UIImage imageNamed:@"Placeholder"];
        _state = PhotoRecordStateNew;
    }
    return self;
}

@end
