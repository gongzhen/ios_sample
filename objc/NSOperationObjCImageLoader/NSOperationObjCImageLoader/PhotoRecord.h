//
//  PhotoRecord.h
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoRecord : NSObject

- (instancetype)initWith:(NSString *)name url:(NSURL *)url;

@property(copy, nonatomic) NSString *name;
@property(strong, nonatomic) NSURL *url;
@property(strong, nonatomic) UIImage *image;

@end
