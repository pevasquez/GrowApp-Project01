//
//  DBUser+Management.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBUser.h"

#import <UIKit/UIKit.h>
@class DBBoard;

@interface DBUser (Management)
+ (DBUser *)createNewUser;
+ (DBUser *)fromJson:(NSDictionary *)userData;
- (void)updateWithJson:(NSDictionary *)jsonDictionary;

- (DBBoard *)createBoardFromJson:(NSDictionary *)boardDictionary;
- (void)getBoardsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (NSArray *)getSortedBoards;
@end
