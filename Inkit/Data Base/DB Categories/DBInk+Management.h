//
//  DBInk+Management.h
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBInk.h"
#import <UIKit/UIKit.h>

@interface DBInk (Management)
+ (DBInk *)fromJson:(NSDictionary *)inkData;
- (void)updateWithJson:(NSDictionary *)inkData;
+ (DBInk *)inkWithInk:(DBInk *)ink;
+ (NSArray *)getAllInksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (UIImage *)getInkImage;

- (void)postWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

- (NSString*)getBodyPartsAsString;
- (NSString *)getTattooTypesAsString;
- (NSString *)getArtistsAsString;

- (NSArray *)toArray;
- (NSDictionary *)toDictionary;
+ (NSDictionary *)emptyDictionary;

// Comment Actions
- (void)addCommentWithText:(NSString *)text forUser:(DBUser *)user;
- (void)deleteInk;
@end
