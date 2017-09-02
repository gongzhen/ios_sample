//
//  WeatherService.m
//  Delegate
//
//  Created by zhen gong on 5/22/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import "WeatherService.h"

@implementation WeatherService

-(void)fetchWeather
{
    // fake weather for now
    Weather *weather = [[Weather alloc] init];
    weather.currentTemperature = -20;
    
    if ([self.delegate respondsToSelector:@selector(didFetchWeather:)]) {
        [self.delegate didFetchWeather:weather];
    }
    
}

@end
