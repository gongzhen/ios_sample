//
//  FBSDKViewImpressionTracker.h
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDKViewImpressionTracker : NSObject

+ (instancetype)impressionTrackerWithEventName:(NSString *)eventName;

@property (nonatomic, copy, readonly) NSString *eventName;

- (void)logImpressionWithIdentifier:(NSString *)identifier parameters:(NSDictionary *)parameters;

@end
