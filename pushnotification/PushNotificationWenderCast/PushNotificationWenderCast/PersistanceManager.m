//
//  PersistanceManager.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "PersistanceManager.h"

@implementation PersistanceManager

+(PersistanceManager *)persistanceManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}


- (void)saveItemsToCache:(id)items toFile:(NSString *)file {
    [NSKeyedArchiver archiveRootObject:items toFile:[self itemsCachePathForDocument:file]];
}

- (NSString *)itemsCachePathForDocument:(NSString *)document {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0];
    NSURL *fileURL = [documentsURL URLByAppendingPathComponent:document];
    if (!fileURL) {
        return nil;
    }
    DLog(@"%@", fileURL.path);
    return fileURL.path;
}

- (NSArray *)loadItemsFromCacheForFile:(NSString *)file {
    id cachedItems = [NSKeyedUnarchiver unarchiveObjectWithFile:[self itemsCachePathForDocument:file]];
    NSArray *items = nil;
    if (cachedItems && [cachedItems isKindOfClass:[NSArray class]]) {
        items = [cachedItems copy];
    }
    return items;
}

@end
