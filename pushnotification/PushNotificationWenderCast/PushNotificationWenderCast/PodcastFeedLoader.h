//
//  PodcastFeedLoader.h
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PodcastFeedLoader : NSObject <NSXMLParserDelegate>

-(void)loadFeed:(void(^)(NSArray *))completion;

@end
