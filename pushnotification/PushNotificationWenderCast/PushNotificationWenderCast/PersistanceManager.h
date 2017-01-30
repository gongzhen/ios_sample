//
//  PersistanceManager.h
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistanceManager : NSObject

+ (PersistanceManager *)persistanceManager;

- (void)saveItemsToCache:(id)items toFile:(NSString *)file;

- (NSString *)itemsCachePathForDocument:(NSString *)document;

- (NSArray *)loadItemsFromCacheForFile:(NSString *)file;

@end
