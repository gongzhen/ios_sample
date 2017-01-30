//
//  PodcastItem.h
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
// @help https://blog.soff.es/archiving-objective-c-objects-with-nscoding

@interface PodcastItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSDate *publishedDate;

- (instancetype)initWithTitle:(NSString *)title publishDate:(NSDate *)publishedDate link:(NSString *)link;

@end
