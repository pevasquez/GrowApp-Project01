//
//  AppDelegate.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "DBInk+Management.h"
#import "InkitConstants.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate () <TutorialViewControllerDelegate>

@end

@implementation AppDelegate
#pragma mark - User LogInMethods
// Show the user the logged-out UI
- (void)userLoggedOut
{
    [self setLogInViewController];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    [self setInitialViewController];
}

#pragma mark - ViewControllers
- (void)setLogInViewController
{
    LogInViewController* logInViewController = [[UIStoryboard storyboardWithName:@"OnBoarding" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInViewController"];
    logInViewController.delegate = self;
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:logInViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}

- (void)setSplashViewController
{
    SplashViewController* splashViewController = [[UIStoryboard storyboardWithName:@"OnBoarding" bundle:nil] instantiateViewControllerWithIdentifier:@"SplashViewController"];
    splashViewController.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = splashViewController;
    [self.window makeKeyAndVisible];
}

- (void)setInitialViewController
{
    InkitTabBarController* inkitTabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InkitTabBarController"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = inkitTabBarController;
    [self.window makeKeyAndVisible];
}

- (void)setTutorialViewController
{
    TutorialViewController *tutorialViewController = [[UIStoryboard storyboardWithName:@"Tutorial" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PageViewController"];
    tutorialViewController.tutorialDelegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tutorialViewController;
    [self.window makeKeyAndVisible];
}


#pragma mark - Splash Screen Delegate Methods
- (void)splashScreenDidFinishedLoading
{
    [self setInitialViewController];
}

- (void)splashScreenDidFailToLogUser
{
    [self setLogInViewController];
}

#pragma mark - LogIn Delegate Methods
- (void)logInDidFinishedLoading
{
    [self setSplashViewController];
}

#pragma mark - Tutorial Delegate
- (void)didFinishTutorial
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:true] forKey:kSeenTutorial];
    [self setLogInViewController];
}

#pragma mark - Application Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    // If there's a logged user, silent logIn
    if ([DataManager sharedInstance].activeUser) {
        // log user
        [self setSplashViewController];
    } else {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:kSeenTutorial]) {
            [self setLogInViewController];
        } else {
            [self setTutorialViewController];
        }
    }
    
    // Crashlytics
    [Fabric with:@[CrashlyticsKit]];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation] || [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        return YES;
    }
    return NO;
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
     [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DataManager sharedInstance] saveContext];
}

#pragma mark - Google

@end
