//
//  CellModel.m
//  Meow Fest
//
//  Created by Zhen Gong on 6/21/18.
//  Copyright © 2018 ULS. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)initWithDesc:(NSString *)desc title:(NSString *)title ts:(NSString *)ts url:(NSString *)url {
    if(self = [super init]) {
        _desc = desc;
        _title = title;
        _timestamp = ts;
        _imageURL = url;
        _image = nil;
    }
    return self;
}

@end
