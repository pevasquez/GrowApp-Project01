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

- (void)updateWithDictionary:(NSDictionary *)boardDictionary Target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)deleteWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)getInksWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

- (NSArray *)getInksFromBoard;

- (void)updateWithJson:(NSDictionary *)jsonDictionary;
- (void)addInkToBoard:(DBInk *)ink;
- (void)addInksToBoard:(NSArray *)inksArray;
- (void)removeInkFromBoard:(DBInk *)ink;
- (void)removeInksFromBoard:(NSArray *)inksArray;
- (void)deleteBoard;
@end
