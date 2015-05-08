//
//  AppDelegate.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SplashViewController.h"
#import "LogInViewController.h"
#import "InkitTabBarController.h"
#import "TutorialViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SplashViewControllerDelegate,LogInViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)userLoggedOut;
- (void)setLogInViewController;
@end

