//
//  InkitService.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitService.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "UserService.h"
#import "InkService.h"
#import "BoardService.h"
#import "CommonService.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBUser+Management.h"
#import "DBShop+Management.h"
#import "InkitServiceConstants.h"


@implementation InkitService

+ (NSError *)logInUser:(DBUser *)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService logInUser:user withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)logInUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    return returnError;
}


+ (NSError *)registerUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService registerUser:user withTarget:target completeAction:completeAction completeError:completeError];
}


+ (NSError *)logInUserWithToken:(NSString *)token WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
    // Get ManagedObjectContext from AppDelegate
    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    
    DBUser* user = [DBUser createMockUserInManagedObjectContext:managedObjectContext];
    
    [DataManager sharedInstance].activeUser = user;
    
    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *) logOutUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService logOutUser:user withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [CommonService getBodyPartsWithTarget:target completeAction:completeAction completeError:completeError];
//    NSError* returnError = nil;
//    
//    // Get ManagedObjectContext from AppDelegate
//    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
//    
//    // Creat Mock Body Parts
//    [DBBodyPart createMockBodyPartsInManagedObjectContext:managedObjectContext];
//    
//    // Call complete Action
//    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
//    
//    return returnError;
}

+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [CommonService getTattooTypesWithTarget:target completeAction:completeAction completeError:completeError];
//    NSError* returnError = nil;
//    
//    // Get ManagedObjectContext from AppDelegate
//    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
//    
//    // Creat Mock Body Parts
//    [DBTattooType createMockTattooTypesInManagedObjectContext:managedObjectContext];
//    
//    // Call complete Action
//    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
//    
//    return returnError;
}

+ (NSError *)postInk:(DBInk *)ink WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;

    //return [InkService createInk:ink forUser:ink.user inBoard:ink.inBoard withTarget:target completeAction:completeAction completeError:completeError];

    // Call complete Action
    [target performSelectorOnMainThread:completeAction withObject:ink waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *)postBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [BoardService postBoard:board WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)updateBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [BoardService updateBoard:board WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [BoardService deleteBoard:board WithTarget:target completeAction:completeAction completeError:completeError];
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

+ (NSError *)getDashboardInksWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService getDashboardInksWithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getArtistsForSearchString:(NSString *)searchString withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService getArtistsForSearchString:searchString withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getShopsForSearchString:(NSString *)searchString WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService getShopsForSearchString:searchString withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)likeInk:(DBInk *)ink withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService likeInk:ink withTarget:target completeAction:completeAction completeError:completeError];
}
@end
