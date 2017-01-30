//
//  PodcastStore.h
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistanceManager.h"
#import "PodcastItem.h"

@interface PodcastStore : NSObject

@property (nonatomic, strong, nullable)NSMutableArray<PodcastItem *> *items;

+ (nonnull instancetype)sharedManager;

- (void)refreshItems:(nullable void(^)(BOOL))completion;

@end
