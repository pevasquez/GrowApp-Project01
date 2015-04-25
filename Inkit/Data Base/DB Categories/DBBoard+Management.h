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
+ (DBBoard *)fromJson:(NSDictionary *)boardData;

+ (NSArray *)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)updateWithDictionary:(NSDictionary *)boardDictionary Target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)deleteWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

- (void)updateWithJson:(NSDictionary *)jsonDictionary;
- (NSArray *)getInksFromBoard;
- (void)addInkToBoard:(DBInk *)ink;
- (void)addInksToBoard:(NSArray *)inksArray;
- (void)removeInkFromBoard:(DBInk *)ink;
- (void)removeInksFromBoard:(NSArray *)inksArray;
- (void)deleteBoard;
@end
