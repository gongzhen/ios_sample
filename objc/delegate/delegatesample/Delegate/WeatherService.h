//
//  WeatherService.h
//  Delegate
//
//  Created by zhen gong on 5/22/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

// I am going to call these methods on you...
@protocol WeatherServiceDelegate <NSObject>
-(void)didFetchWeather:(Weather *)weather;
@end

@interface WeatherService : NSObject

-(void)fetchWeather;
@property (nonatomic, weak) id <WeatherServiceDelegate> delegate;

@end
