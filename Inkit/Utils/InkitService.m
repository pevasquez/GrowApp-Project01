//
//  InkitService.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitService.h"
#import "AppDelegate.h"
#import "UserService.h"
#import "InkService.h"
#import "BoardService.h"
#import "CommonService.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBUser+Management.h"
#import "DBShop+Management.h"
#import "DBInk+Management.h"
#import "InkitServiceConstants.h"
#import "FacebookManager.h"


@implementation InkitService

+ (void)logInUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion {
    [UserService logInUserDictionary:userDictionary withCompletion:completion];
}

+ (void)registerUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion {
    [UserService registerUserDictionary:userDictionary withCompletion:completion];
}

+ (void)logInSocialDictionary:(NSDictionary *)facebookDictionary withCompletion:(ServiceResponse)completion {
    [UserService logInSocialDictionary:facebookDictionary withCompletion:completion];
}

+ (void)logOutUser:(DBUser *)user withCompletion:(ServiceResponse)completion {
    [UserService logOutUser:user withCompletion:completion];
}

+ (void)getBodyPartsWithCompletion:(ServiceResponse)completion {
    [CommonService getBodyPartsWithCompletion:completion];
}

+ (void)getTattooTypesWithCompletion:(ServiceResponse)completion {
    [CommonService getTattooTypesWithCompletion:completion];
}

#pragma mark - Inks Service
+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    return [InkService createInk:inkDictionary withTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)updateInk:(DBInk *)ink withDictionary:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    return [InkService updateInk:ink withDictionary:inkDictionary withTarget:target completeAction:completeAction completeError:completeError];
}

// MARK:- Board Service
+ (NSError *)postBoard:(NSDictionary *)boardDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    return [BoardService postBoard:boardDictionary WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)updateBoard:(DBBoard *)board withDictionary:(NSDictionary *)boardDictionary target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError; {
    return [BoardService updateBoard:board withDictionary:boardDictionary target:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    return [BoardService deleteBoard:board WithTarget:target completeAction:completeAction completeError:completeError];
}

+ (NSError *)getBoardsForUser:(DBUser*)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
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

+ (void)getRelatedInksForInk:(DBInk*)ink andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion {
    [InkService getRelatedInksForInk:ink andPage:page withCompletion:completion];
}
@end
