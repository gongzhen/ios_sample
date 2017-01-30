//
//  DateParser.h
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DateParser : NSObject

+ (NSDateFormatter *)dateFormatter;

+ (NSDate *)dateWithPodcastDateString:(NSString *)dateString;

+ (NSString *)displayStringForDate:(NSDate *)date;

@end
