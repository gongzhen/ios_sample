//
//  DateParser.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/7/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "DateParser.h"

@implementation DateParser

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    return dateFormatter;
}

+ (NSDate *)dateWithPodcastDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)displayStringForDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"HH:mm MMMM dd, yyyy"];
    return [dateFormatter stringFromDate:date];
}

@end
