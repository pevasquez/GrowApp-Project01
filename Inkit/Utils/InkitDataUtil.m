//
//  InkitDataUtil.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitDataUtil.h"
#import "AppDelegate.h"

#define kActiveUser         @"kActiveUser"
@class DBUser;
@implementation InkitDataUtil
+ (id)sharedInstance
{
    static InkitDataUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        [self obtainCurrentUser];
    }
    return self;
}

#pragma mark - Active User Management

- (void)obtainCurrentUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL* activeUserIDURL = [userDefaults objectForKey:kActiveUser];
    if (activeUserIDURL) {
        AppDelegate* appDelegate = ((AppDelegate*)([[UIApplication sharedApplication] delegate]));
        NSPersistentStoreCoordinator *persistentStoreCoordinator = appDelegate.persistentStoreCoordinator;
        NSManagedObjectContext* managedObjectContext = appDelegate.managedObjectContext;
        NSManagedObjectID *moID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:activeUserIDURL];
        self.activeUser = (DBUser *)[managedObjectContext objectWithID:moID];
    }
}

- (void)setActiveUser:(DBUser *)__activeUser
{
    _activeUser = __activeUser;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (_activeUser) {
        //NSURL *activeUserIDURL = [[_activeUser objectID] URIRepresentation];
        //[userDefaults setObject:activeUserIDURL forKey:kActiveUser];
    } else {
        [userDefaults removeObjectForKey:kActiveUser];
    }
    
    [userDefaults synchronize];
}

@end
