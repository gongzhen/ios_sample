//
//  PendingOperations.h
//  NSOperationObjCImageLoader
//
//  Created by zhen gong on 8/27/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject

@property (strong, nonatomic) NSMutableDictionary *downloadsInProgress;
@property (strong, nonatomic) NSOperationQueue* downloadQueue;
@property (strong, nonatomic) NSMutableDictionary *map;

- (void)updateMapWithKey:(NSString *)key;

@end
