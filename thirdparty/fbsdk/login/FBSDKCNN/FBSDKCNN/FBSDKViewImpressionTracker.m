//
//  FBSDKViewImpressionTracker.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/14/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKViewImpressionTracker.h"
#import "AppDelegate.h"
#import "FBSDKAppEvents.h"
#import "FBSDKAccessToken.h"

@implementation FBSDKViewImpressionTracker
{
    NSMutableSet *_trackedImpressions;
}

#pragma mark - Class Methods

+ (instancetype)impressionTrackerWithEventName:(NSString *)eventName
{
    static NSMutableDictionary *_impressionTrackers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _impressionTrackers = [[NSMutableDictionary alloc] init];
    });
    // Maintains a single instance of an impression tracker for each event name
    FBSDKViewImpressionTracker *impressionTracker = _impressionTrackers[eventName];
    if (!impressionTracker) {
        impressionTracker = [[self alloc] initWithEventName:eventName];
        _impressionTrackers[eventName] = impressionTracker;
    }
    return impressionTracker;
}

#pragma mark - Object Lifecycle

- (instancetype)initWithEventName:(NSString *)eventName
{
    if ((self = [super init])) {
        _eventName = [eventName copy];
        _trackedImpressions = [[NSMutableSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_applicationDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public API

- (void)logImpressionWithIdentifier:(NSString *)identifier parameters:(NSDictionary *)parameters
{
    NSMutableDictionary *keys = [NSMutableDictionary dictionary];
    keys[@"__view_impression_identifier__"] = identifier;
    [keys addEntriesFromDictionary:parameters];
    NSDictionary *impressionKey = [keys copy];
    // Ensure that each impression is only tracked once
    if ([_trackedImpressions containsObject:impressionKey]) {
        return;
    }
    [_trackedImpressions addObject:impressionKey];
    
    [FBSDKAppEvents logImplicitEvent:self.eventName
                          valueToSum:nil
                          parameters:parameters
                         accessToken:[FBSDKAccessToken currentAccessToken]];
}

#pragma mark - Helper Methods

- (void)_applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    // reset all tracked impressions when the app backgrounds so we will start tracking them again the next time they
    // are triggered.
    [_trackedImpressions removeAllObjects];
}

@end
