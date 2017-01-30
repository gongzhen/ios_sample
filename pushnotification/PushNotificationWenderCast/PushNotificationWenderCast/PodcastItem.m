//
//  PodcastItem.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "PodcastItem.h"

static NSString *const Title = @"title";
static NSString *const Date = @"date";
static NSString *const Link = @"link";

@implementation PodcastItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:Title];
        self.link = [aDecoder decodeObjectForKey:Link];
        self.publishedDate = [aDecoder decodeObjectForKey:Date];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title publishDate:(NSDate *)publishedDate link:(NSString *)link {
    if (self = [super init]) {
        _title = title;
        _link = link;
        _publishedDate = publishedDate;
    }
    return self;
}

#pragma mark NSCoding delegate method

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:Title];
    [aCoder encodeObject:self.link forKey:Link];
    [aCoder encodeObject:self.publishedDate forKey:Date];
}

@end
