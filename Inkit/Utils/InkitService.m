//
//  InkitService.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitService.h"
#import "InkitDataUtil.h"
#import "AppDelegate.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBUser+Management.h"

@implementation InkitService
+ (NSError *)logInUsername:(NSString *)username AndPassword:(NSString *)password WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    DBUser* user = [DBUser createMockUserInManagedObjectContext:managedObjectContext];
    
    [InkitDataUtil sharedInstance].activeUser = user;
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)logInUserWithToken:(NSString *)token WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    DBUser* user = [DBUser createMockUserInManagedObjectContext:managedObjectContext];
    
    [InkitDataUtil sharedInstance].activeUser = user;
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    // Creat Mock Body Parts
    [DBBodyPart createMockBodyPartsInManagedObjectContext:managedObjectContext];
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    // Creat Mock Body Parts
    [DBTattooType createMockTattooTypesInManagedObjectContext:managedObjectContext];
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postInk:(DBInk *)ink WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    // Create Ink in DB

    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:ink waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Create Ink in DB
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:board waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)getBoardsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postComment:(DBComment*)comment withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

@end
