//
//  DBBoard+Management.h
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBBoard.h"
#import <UIKit/UIKit.h>

@interface DBBoard (Management)
+ (DBBoard *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBBoard *)createWithTitle:(NSString *)title AndDescription:(NSString *)boardDescription InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSArray *)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;;

- (void)postWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (NSArray *)getInksFromBoard;
- (void)addInkToBoard:(DBInk *)ink;
- (void)addInksToBoard:(NSArray *)inksArray;
- (DBInk *)createInkWithImage:(UIImage *)image AndDescription:(NSString *)description;
- (void)removeInkFromBoard:(DBInk *)ink;
- (void)removeInksFromBoard:(NSArray *)inksArray;
@end
