//
//  AppDelegate.m
//  AppleLazyTableViewCellProject
//
//  Created by Admin  on 4/26/18.
//  Copyright © 2018 Admin . All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface AppDelegate ()

@property(strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Create a tabBar controller
    self.tabBarController = [[UITabBarController alloc] sf];
    
    // Create firstViewController obj
    FirstViewController *firstViewController = [[FirstViewController alloc] init];
    // Create navigationController to navigate firstViewController
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController: firstViewController];
    firstNavigationController.tabBarItem.title = @"First";
    
    // Create secondViewController obj
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    // Create navigationController to navigate firstViewController
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController: secondViewController];
    secondNavigationController.tabBarItem.title = @"Second";
    // Assemble navigation controllers to array
    NSArray *controllers = [NSArray arrayWithObjects:firstNavigationController, secondNavigationController, nil];
    // Assign controllers array to tabBarController
    self.tabBarController.viewControllers = controllers;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor grayColor];
    shadow.shadowOffset = CGSizeMake(0, 1.0);
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20.f],
                                                        NSForegroundColorAttributeName:[UIColor redColor],
                                                        NSShadowAttributeName: shadow}
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:20.f],
                                                        NSForegroundColorAttributeName:[UIColor blackColor],
                                                        NSShadowAttributeName: shadow}
                                             forState:UIControlStateNormal];
    
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    // Set window's rootViewController with tabBarController
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
