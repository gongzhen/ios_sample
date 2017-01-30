//
//  AppDelegate.m
//  DetectiOSVersion
//
//  Created by gongzhen on 12/12/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

#import "AppDelegate.h"
#import <mach-o/dyld.h>
#import <sys/time.h>

typedef NS_ENUM(int32_t, FBSDKUIKitVersion)
{
    FBSDKUIKitVersion_6_0 = 0X0944,
    FBSDKUIKitVersion_6_1 = 0x094C,
    FBSDKUIKitVersion_7_0 = 0x0B57,
    FBSDKUIKitVersion_7_1 = 0x0B77,
    FBSDKUIKitVersion_8_0 = 0x0CF6,
};

typedef NS_ENUM(NSUInteger, FBSDKInternalUtilityVersionMask)
{
    FBSDKInternalUtilityMajorVersionMask = 0xFFFF0000,
};

typedef NS_ENUM(NSUInteger, FBSDKInternalUtilityVersionShift)
{
    FBSDKInternalUtilityMajorVersionShift = 16,
};

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSOperatingSystemVersion iOS10Version = {.majorVersion = 10, .minorVersion = 0, .patchVersion = 0};
        
        if ([AppDelegate _isOSRunTimeVersionAtLeast:iOS10Version]) {
            DLog(@"iOS10Version %ld", iOS10Version.majorVersion);
            // [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            
        }
        DLog(@"OSRunTimeVersionAtLeast %u", [AppDelegate _isOSRunTimeVersionAtLeast:iOS10Version]);
    });
    
    return YES;
}

+ (BOOL)_isOSRunTimeVersionAtLeast:(NSOperatingSystemVersion)version {
    // version 10.0.0
    return ([self _compareOperatingSystemVersion:[self operatingSystemVersion] toVersion:version] != NSOrderedAscending);
}

+ (NSComparisonResult)_compareOperatingSystemVersion:(NSOperatingSystemVersion)version1 toVersion:(NSOperatingSystemVersion)version2 {
    DLog(@"version 1 major %ld", version1.majorVersion);// version 1: 9.3.0 version 2:10.0.0
    DLog(@"version 2 major %ld", version2.majorVersion);
    DLog(@"version 1 minor %ld", version1.minorVersion);
    DLog(@"version 2 minor %ld", version2.minorVersion);
    DLog(@"version 1 patch %ld", version1.patchVersion);
    DLog(@"version 2 patch %ld", version2.patchVersion);
    
    if (version1.majorVersion < version2.majorVersion) {
        return NSOrderedAscending;
    } else if (version1.majorVersion > version2.majorVersion) {
        return NSOrderedDescending;
    } else if (version1.minorVersion < version2.minorVersion) {
        return NSOrderedAscending;
    } else if (version1.minorVersion > version2.minorVersion) {
        return NSOrderedDescending;
    } else if (version1.patchVersion < version2.patchVersion) {
        return NSOrderedAscending;
    } else if (version1.patchVersion > version2.patchVersion) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

+ (NSOperatingSystemVersion)operatingSystemVersion {
    static NSOperatingSystemVersion operatingSystemVersion = {
        .majorVersion = 0,
        .minorVersion = 0,
        .patchVersion = 0,
    };
    
    static dispatch_once_t getVersionOnce;
    
    dispatch_once(&getVersionOnce, ^{
        if ([NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)]) {
            DLog(@"operatingSystemVersion %ld", [NSProcessInfo processInfo].operatingSystemVersion.majorVersion); // 9.3.0
            DLog(@"operatingSystemVersion %ld", [NSProcessInfo processInfo].operatingSystemVersion.minorVersion);
            DLog(@"operatingSystemVersion %ld", [NSProcessInfo processInfo].operatingSystemVersion.patchVersion);
            operatingSystemVersion = [NSProcessInfo processInfo].operatingSystemVersion;
        } else {
            NSArray *components = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
            DLog(@"components %@", components);
            switch (components.count) {
                default:
                case 3:
                    operatingSystemVersion.patchVersion = [components[2] integerValue];
                    // fall through
                case 2:
                    operatingSystemVersion.minorVersion  = [components[1] integerValue];
                    // fall through
                case 1:
                    operatingSystemVersion.majorVersion = [components[0] integerValue];
                    break;
                case 0:
                    operatingSystemVersion.majorVersion = ([self isUIKitLinkTimeVersionAtLeast:FBSDKUIKitVersion_7_0] ? 7 : 6);
                    break;
            }
        }
    });
    return operatingSystemVersion;
}

+ (BOOL)isUIKitLinkTimeVersionAtLeast:(FBSDKUIKitVersion)version {
    static int32_t linkTimeMajorVersion;
    static dispatch_once_t getVersionOnce;
    
    dispatch_once(&getVersionOnce, ^{
        int32_t linkTimeVersion = NSVersionOfLinkTimeLibrary("UIKit");
        linkTimeMajorVersion = ((MAX(linkTimeVersion, 0) & FBSDKInternalUtilityMajorVersionMask) >> FBSDKInternalUtilityMajorVersionShift);
    });
    return (version <= linkTimeMajorVersion);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
