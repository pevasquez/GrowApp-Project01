//
//  InkitService.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBInk+Management.h"
#import "DBUser+Management.h"

@class DBUser, DBBoard;
@interface InkitService : NSObject

+ (NSError *)logInUserDictionary:(NSDictionary *)userDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (NSError *)logInSocialDictionary:(NSDictionary *)facebookDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (NSError *)logOutUser:(DBUser *)user WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

// Register DBUser to Inkit
+ (NSError *)registerUserDictionary:(NSDictionary *)userDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (NSError *)logInUserWithToken:(NSString *)token WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

// Board Service
+ (NSError *)postBoard:(NSDictionary *)boardDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)updateBoard:(DBBoard *)board withDictionary:(NSDictionary *)boardDictionary target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)getBoardsForUser:(DBUser*)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (void)getInksFromBoard:(DBBoard *)board withCompletion:(ServiceResponse)completion;

// Ink Service
+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)updateInk:(DBInk *)ink withDictionary:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (void)getDashboardInksForPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;
+ (void)getInksForSearchString:(NSString *)searchString andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;

+ (NSError *)getRemotesForSearchString:(NSString *)searchString type:(NSString *)type withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (void)likeInk:(DBInk *)ink completion:(ServiceResponse)completion;
+ (void)unlikeInk:(DBInk *)ink completion:(ServiceResponse)completion;
+ (void)deleteInk:(DBInk *)ink completion:(ServiceResponse)completion;
+ (void)postComment:(NSString *)comment toInk:(DBInk*)ink completion:(ServiceResponse)completion;
+ (void)getCommentsForInk:(DBInk*)ink completion:(ServiceResponse)completion;
+ (void)getRelatedInksForInk:(DBInk*)ink andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;
@end
