//
//  FBSDKAppEvents.m
//  FBSDKCNN
//
//  Created by gongzhen on 1/15/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "FBSDKAppEvents.h"
#import "FBSDKAccessToken.h"
#import "FBSDKAppEventsUtility.h"

NSString *const FBSDKAppEventNameFBSDKLoginButtonImpression       = @"fb_login_button_impression";

@implementation FBSDKAppEvents
{
    BOOL _explicitEventsLoggedYet;
    NSTimer *_flushTimer;
    NSTimer *_attributionIDRecheckTimer;
//    FBSDKServerConfiguration *_serverConfiguration;
//    FBSDKAppEventsState *_appEventsState;
    NSString *_userID;
}



#pragma mark - Internal Methods

+ (void)logImplicitEvent:(NSString *)eventName
              valueToSum:(NSNumber *)valueToSum
              parameters:(NSDictionary *)parameters
             accessToken:(FBSDKAccessToken *)accessToken
{
    [[FBSDKAppEvents singleton] instanceLogEvent:eventName
                                      valueToSum:valueToSum
                                      parameters:parameters
                              isImplicitlyLogged:YES
                                     accessToken:accessToken];
}

+ (FBSDKAppEvents *)singleton
{
    static dispatch_once_t pred;
    static FBSDKAppEvents *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[FBSDKAppEvents alloc] init];
    });
    return shared;
}

#pragma mark - Private Methods

- (void)instanceLogEvent:(NSString *)eventName
              valueToSum:(NSNumber *)valueToSum
              parameters:(NSDictionary *)parameters
      isImplicitlyLogged:(BOOL)isImplicitlyLogged
             accessToken:(FBSDKAccessToken *)accessToken
{
//    if (isImplicitlyLogged && _serverConfiguration && !_serverConfiguration.isImplicitLoggingSupported) {
//        return;
//    }
//    
//    if (!isImplicitlyLogged && !_explicitEventsLoggedYet) {
//        _explicitEventsLoggedYet = YES;
//    }
//    
//    __block BOOL failed = NO;
//    
//    if (![FBSDKAppEventsUtility validateIdentifier:eventName]) {
//        failed = YES;
//    }
//    
//    // Make sure parameter dictionary is well formed.  Log and exit if not.
//    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if (![key isKindOfClass:[NSString class]]) {
//            [FBSDKAppEventsUtility logAndNotify:[NSString stringWithFormat:@"The keys in the parameters must be NSStrings, '%@' is not.", key]];
//            failed = YES;
//        }
//        if (![FBSDKAppEventsUtility validateIdentifier:key]) {
//            failed = YES;
//        }
//        if (![obj isKindOfClass:[NSString class]] && ![obj isKindOfClass:[NSNumber class]]) {
//            [FBSDKAppEventsUtility logAndNotify:[NSString stringWithFormat:@"The values in the parameters dictionary must be NSStrings or NSNumbers, '%@' is not.", obj]];
//            failed = YES;
//        }
//    }
//     ];
    
//    if (failed) {
//        return;
//    }
//    
//    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    eventDictionary[FBSDKAppEventParameterEventName] = eventName;
//    if (!eventDictionary[FBSDKAppEventParameterLogTime]) {
//        eventDictionary[FBSDKAppEventParameterLogTime] = @([FBSDKAppEventsUtility unixTimeNow]);
//    }
//    [FBSDKInternalUtility dictionary:eventDictionary setObject:valueToSum forKey:@"_valueToSum"];
//    if (isImplicitlyLogged) {
//        eventDictionary[FBSDKAppEventParameterImplicitlyLogged] = @"1";
//    }
//    [FBSDKInternalUtility dictionary:eventDictionary setObject:_userID forKey:@"_app_user_id"];
//    
//    NSString *currentViewControllerName;
//    if ([NSThread isMainThread]) {
//        // We only collect the view controller when on the main thread, as the behavior off
//        // the main thread is unpredictable.  Besides, UI state for off-main-thread computations
//        // isn't really relevant anyhow.
//        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
//        if (vc) {
//            currentViewControllerName = [[vc class] description];
//        } else {
//            currentViewControllerName = @"no_ui";
//        }
//    } else {
//        currentViewControllerName = @"off_thread";
//    }
//    eventDictionary[@"_ui"] = currentViewControllerName;
//    
//    NSString *tokenString = [FBSDKAppEventsUtility tokenStringToUseFor:accessToken];
//    NSString *appID = [self appID];
//    
//    @synchronized (self) {
//        if (!_appEventsState) {
//            _appEventsState = [[FBSDKAppEventsState alloc] initWithToken:tokenString appID:appID];
//        } else if (![_appEventsState isCompatibleWithTokenString:tokenString appID:appID]) {
//            if (self.flushBehavior == FBSDKAppEventsFlushBehaviorExplicitOnly) {
//                [FBSDKAppEventsStateManager persistAppEventsData:_appEventsState];
//            } else {
//                [self flushForReason:FBSDKAppEventsFlushReasonSessionChange];
//            }
//            _appEventsState = [[FBSDKAppEventsState alloc] initWithToken:tokenString appID:appID];
//        }
//        
//        [_appEventsState addEvent:eventDictionary isImplicit:isImplicitlyLogged];
//        if (!isImplicitlyLogged) {
//            [FBSDKLogger singleShotLogEntry:FBSDKLoggingBehaviorAppEvents
//                               formatString:@"FBSDKAppEvents: Recording event @ %ld: %@",
//             [FBSDKAppEventsUtility unixTimeNow],
//             eventDictionary];
//        }
//        
//        [self checkPersistedEvents];
//        
//        if (_appEventsState.events.count > NUM_LOG_EVENTS_TO_TRY_TO_FLUSH_AFTER &&
//            self.flushBehavior != FBSDKAppEventsFlushBehaviorExplicitOnly) {
//            [self flushForReason:FBSDKAppEventsFlushReasonEventThreshold];
//        }
//    }
}


@end
