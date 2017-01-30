//
//  PodcastStore.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "PodcastStore.h"
#import "PodcastFeedLoader.h"
#import "PersistanceManager.h"

@implementation PodcastStore

// This will prevent a subclass that is not a member of MyFinalClassName from being alloc.
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    if (self != [PodcastStore class]) {
        NSAssert(nil, @"Subclassing MyFinalClassName not allowed.");
        return nil;
    }
    return [super allocWithZone:zone];
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *file = [[PersistanceManager persistanceManager] itemsCachePathForDocument:@"podcasts.dat"];
        if (file) {
            self.items = [[[PersistanceManager persistanceManager] loadItemsFromCacheForFile:file] copy];
        }
    }
    return self;
}

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PodcastStore *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)refreshItems:(nullable void(^)(BOOL))completion {
    PodcastFeedLoader *loader = [[PodcastFeedLoader alloc] init];
    [loader loadFeed:^(NSArray *items) {
        
        BOOL didLoadNewItems = items.count > _items.count ;
        _items = [items copy];
        [[PersistanceManager persistanceManager] saveItemsToCache:_items toFile:@"podcasts.dat"];
        completion(didLoadNewItems);
    }];
}




@end
