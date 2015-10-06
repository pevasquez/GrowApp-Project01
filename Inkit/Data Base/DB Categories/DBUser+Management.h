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
+ (DBUser *)fromJson:(NSDictionary *)userData;
- (void)updateWithJson:(NSDictionary *)jsonDictionary;

- (DBBoard *)createBoardFromJson:(NSDictionary *)boardDictionary;

- (void)getBoardsWithCompletionHandler:(ServiceResponse)completion;

- (NSArray *)getSortedBoards;
@end
