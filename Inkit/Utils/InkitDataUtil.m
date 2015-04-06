//
//  InkitDataUtil.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitDataUtil.h"
#import "AppDelegate.h"
#import "DBUser+Management.h"

#define kActiveUser         @"kActiveUser"
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
    NSData* userData = [userDefaults objectForKey:kActiveUser];
    if (userData) {
        NSURL* activeUserIDURL = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if (activeUserIDURL) {
            AppDelegate* appDelegate = ((AppDelegate*)([[UIApplication sharedApplication] delegate]));
            NSPersistentStoreCoordinator *persistentStoreCoordinator = appDelegate.persistentStoreCoordinator;
            NSManagedObjectContext* managedObjectContext = appDelegate.managedObjectContext;
            NSManagedObjectID *objectID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:activeUserIDURL];
            if (!objectID) {
                return;
            }
            NSManagedObject* objectForID = [managedObjectContext objectWithID:objectID];
            if (![objectForID isFault]) {
                DBUser* user = (DBUser *)[managedObjectContext objectWithID:objectID];
                self.activeUser = user;
            }
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            [request setEntity:[objectID entity]];
            
            NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForEvaluatedObject]
                                                                        rightExpression:[NSExpression expressionForConstantValue:objectForID]
                                                                               modifier:NSDirectPredicateModifier
                                                                                   type:NSEqualToPredicateOperatorType
                                                                                options:0];
            
            [request setPredicate:predicate];
            
            NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
            if ([results count] > 0 )
            {
                DBUser* user = (DBUser *)[managedObjectContext objectWithID:objectID];
                self.activeUser = user;
            }
        }
    }
}

@synthesize activeUser;

- (void)setActiveUser:(DBUser *)user
{
    activeUser = user;
    
    AppDelegate* appDelegate = ((AppDelegate*)([[UIApplication sharedApplication] delegate]));
    NSManagedObjectContext* managedObjectContext = appDelegate.managedObjectContext;

    NSError* error = nil;
    [managedObjectContext save:&error];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (activeUser) {
        NSURL *activeUserIDURL = [[activeUser objectID] URIRepresentation];
        NSData *activeUserData = [NSKeyedArchiver archivedDataWithRootObject:activeUserIDURL];
        [userDefaults setObject:activeUserData forKey:kActiveUser];
    } else {
        [userDefaults removeObjectForKey:kActiveUser];
    }
    
    [userDefaults synchronize];
}

- (DBUser *)activeUser
{
    if (!activeUser) {
        [self obtainCurrentUser];
    }
    return activeUser;
}

@end
