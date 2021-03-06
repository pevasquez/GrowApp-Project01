//
//  InkService.h
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBUser+Management.h"
#import "DBInk+Management.h"
#import "DBBoard+Management.h"
#import "DBComment+Management.h"

@interface InkService : NSObject

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

+ (void)getRelatedInksForInk:(DBInk*)ink andPage:(NSUInteger)page withCompletion:(ServiceResponse)completion;

+ (void)reportInk:(DBInk *)ink withReason:(DBReportReason *)reportReason completion:(ServiceResponse)completion;

@end
