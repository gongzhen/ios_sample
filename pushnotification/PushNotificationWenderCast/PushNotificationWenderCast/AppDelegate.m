//
//  AppDelegate.m
//  PushNotificationWenderCast
//
//  Created by gongzhen on 1/6/17.
//  Copyright © 2017 gongzhen. All rights reserved.
//

#import "AppDelegate.h"
#import "PodcastFeedTableViewController.h"
#import "NewsFeedTableViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    NSDictionary *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notification) {
        // NSDictionary *aps = [notification objectForKey:@"aps"];
        
        self.tabBarController.selectedIndex = 1;
    }
    
    // Override point for customization after application launch.
    self.tabBarController = [[UITabBarController alloc] init];
    
    PodcastFeedTableViewController *podcastFeedController = [[PodcastFeedTableViewController alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:podcastFeedController];
    firstNavigationController.tabBarItem.title = @"Pod Cast";
    
    
    NewsFeedTableViewController *newsFeedTableViewController = [[NewsFeedTableViewController alloc] init];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:newsFeedTableViewController];
    secondNavigationController.tabBarItem.title = @"News Feed";
    
    NSArray *controllersArray = @[firstNavigationController, secondNavigationController];
    
    self.tabBarController.viewControllers = controllersArray;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:104/255.0 blue:51/255.0 alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark register for push

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}


- (void) registerForPushNotifications:(UIApplication *)application {
    UIMutableUserNotificationAction *viewAction = [[UIMutableUserNotificationAction alloc] init];    
    viewAction.identifier = @"VIEW_IDENTIFIER";
    viewAction.title = @"View";
    [viewAction setActivationMode:UIUserNotificationActivationModeForeground];
    
    UIMutableUserNotificationCategory *newsCategory = [[UIMutableUserNotificationCategory alloc] init];
    newsCategory.identifier = @"NEWS_CATEGORY";
    [newsCategory setActions:@[viewAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet<UIUserNotificationCategory* > *categories = [[NSSet alloc] init];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
    [application registerUserNotificationSettings:notificationSettings];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    NSString *deviceTokenString = deviceToken.description;
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"---Token--%@ ", deviceTokenString);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // need to work on.
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