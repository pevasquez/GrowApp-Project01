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
+ (DBBoard *)createNewBoard;
+ (DBBoard *)createWithTitle:(NSString *)title AndDescription:(NSString *)boardDescription;

+ (NSArray *)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;;

- (void)postWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)updateWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)deleteWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

- (void)updateWithJson:(NSDictionary *)jsonDictionary;
- (NSArray *)getInksFromBoard;
- (void)addInkToBoard:(DBInk *)ink;
- (void)addInksToBoard:(NSArray *)inksArray;
- (void)removeInkFromBoard:(DBInk *)ink;
- (void)removeInksFromBoard:(NSArray *)inksArray;
- (void)deleteBoard;
@end
