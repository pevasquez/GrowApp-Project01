//
//  InkitService.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InkitServiceConstants.h"

@class DBUser, DBBoard, DBInk, DBReportReason;

@interface InkitService : NSObject

// User Methods
+ (void)logInUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion;

+ (void)logInSocialDictionary:(NSDictionary *)facebookDictionary withCompletion:(ServiceResponse)completion;

+ (void)logOutUser:(DBUser *)user withCompletion:(ServiceResponse)completion;

+ (void)registerUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion;

+ (void)registerArtistDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion;

+ (void)registerShopDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion;

// Common Methods
+ (void)getBodyPartsWithCompletion:(ServiceResponse)completion;

+ (void)getTattooTypesWithCompletion:(ServiceResponse)completion;

+ (void)getReportReasons:(ServiceResponse)completion;

// Board Service
+ (NSError *)postBoard:(NSDictionary *)boardDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)updateBoard:(DBBoard *)board withDictionary:(NSDictionary *)boardDictionary target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (void)getBoardsForUser:(DBUser*)user withCompletionHandler:(ServiceResponse)completion;

+ (void)getInksFromBoard:(DBBoard *)board withCompletion:(ServiceResponse)completion;

// Ink Service
+ (NSError *)createInk:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)updateInk:(DBInk *)ink withDictionary:(NSDictionary *)inkDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)getRemotesForSearchString:(NSString *)searchString type:(NSString *)type withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (void)getDashboardInksForPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;

+ (void)getInksForSearchString:(NSString *)searchString andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;

+ (void)likeInk:(DBInk *)ink completion:(ServiceResponse)completion;

+ (void)unlikeInk:(DBInk *)ink completion:(ServiceResponse)completion;

+ (void)deleteInk:(DBInk *)ink completion:(ServiceResponse)completion;

+ (void)postComment:(NSString *)comment toInk:(DBInk*)ink completion:(ServiceResponse)completion;

+ (void)getCommentsForInk:(DBInk*)ink completion:(ServiceResponse)completion;

+ (void)reportInk:(DBInk*)ink withReason:(DBReportReason *)reportReason completion:(ServiceResponse)completion;

+ (void)getRelatedInksForInk:(DBInk*)ink andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;

@end
