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
+ (DBInk *)createNewInk;
+ (DBInk *)createWithImage:(UIImage *)image AndDescription:(NSString *)inkDescription InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBInk *)inkWithInk:(DBInk *)ink;
+ (NSArray *)getAllInksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (UIImage *)getInkImage;

- (void)postWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

- (NSString*)getBodyPartsAsString;
- (NSString *)getTattooTypesAsString;
- (NSString *)getArtistsAsString;

+ (DBInk *)fromJson:(NSDictionary *)inkData;

// Comment Actions
- (void)addCommentWithText:(NSString *)text forUser:(DBUser *)user;

@end
