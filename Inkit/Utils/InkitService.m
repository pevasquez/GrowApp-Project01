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
#import "FacebookManager.h"


@implementation InkitService

+ (NSError *)logInUserDictionary:(NSDictionary *)userDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService logInUserDictionary:userDictionary withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)registerUserDictionary:(NSDictionary *)userDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
{
    return [UserService registerUserDictionary:userDictionary WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)logInSocialDictionary:(NSDictionary *)facebookDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
{
    return [UserService logInSocialDictionary:facebookDictionary withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)logInUserWithToken:(NSString *)token WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    NSError* returnError = nil;
    
//    // Get ManagedObjectContext from AppDelegate
//    NSManagedObjectContext* managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
//    
//    DBUser* user = [DBUser createMockUserInManagedObjectContext:managedObjectContext];
//    
//    [DataManager sharedInstance].activeUser = user;
//    
//    // Call complete Action
//    [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    
    return returnError;
}

+ (NSError *) logOutUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [UserService logOutUser:user withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [CommonService getBodyPartsWithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [CommonService getTattooTypesWithTarget:target completeAction:completeAction completeError:completeError];
}

#pragma mark - Inks Service
+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService createInk:inkDictionary withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)updateInk:(DBInk *)ink withDictionary:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [InkService updateInk:ink withDictionary:inkDictionary withTarget:target completeAction:completeAction completeError:completeError];
}

// MARK:- Board Service
+ (NSError *)postBoard:(NSDictionary *)boardDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [BoardService postBoard:boardDictionary WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)updateBoard:(DBBoard *)board withDictionary:(NSDictionary *)boardDictionary target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
{
    return [BoardService updateBoard:board withDictionary:boardDictionary target:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [BoardService deleteBoard:board WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getBoardsForUser:(DBUser*)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    return [BoardService getBoardsForUser:user withTarget:target completeAction:completeAction completeError:completeError];
}

+ (void)getInksFromBoard:(DBBoard *)board withCompletion:(ServiceResponse)completion {
    [BoardService getInksFromBoard:board withCompletion:completion];
}

+ (void)getDashboardInksForPage:(NSUInteger)page withCompletion:(ServiceResponse)completion {
    [InkService getDashboardInksForPage:page withCompletion:completion];
}

+ (void)getInksForSearchString:(NSString *)searchString andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion {
    [InkService getInksForSearchString:searchString andPage:page withCompletion:completion];
}

+ (NSError *)getRemotesForSearchString:(NSString *)searchString type:(NSString *)type withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    
    return [InkService getRemotesForSearchString:searchString type:type withTarget:target completeAction:completeAction completeError:completeError];
}

+ (void)likeInk:(DBInk *)ink completion:(ServiceResponse)completion {
    [InkService likeInk:ink completion:completion];
}

+ (void)unlikeInk:(DBInk *)ink completion:(ServiceResponse)completion {
    [InkService unlikeInk:ink completion:completion];
}

+ (void)deleteInk:(DBInk *)ink completion:(ServiceResponse)completion {
    [InkService deleteInk:ink completion:completion];
}

+ (void)postComment:(NSString *)comment toInk:(DBInk*)ink completion:(ServiceResponse)completion {
    [InkService postComment:comment toInk:ink completion:completion];
}

+ (void)getCommentsForInk:(DBInk *)ink completion:(ServiceResponse)completion {
    [InkService getCommentsForInk:ink completion:completion];
}

@end
