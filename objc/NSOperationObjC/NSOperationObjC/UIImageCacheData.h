//
//  UIImageCacheData.h
//  NSOperationObjC
//
//  Created by zhen gong on 8/26/17.
//  Copyright © 2017 Admin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageCacheData : NSObject

@property NSTimeInterval maxage;
@property NSString * etag;
@property NSString * lastModified;
@property BOOL nocache;
//for errors 4XX,5XX
@property NSInteger errorAttempts;
@property NSTimeInterval errorMaxage;
@property NSError * errorLast;

@end
