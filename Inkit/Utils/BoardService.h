//
//  BoardService.h
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBoard+Management.h"
#import "DBUser+Management.h"
#import "DBInk+Management.h"

@interface BoardService : NSObject
+ (NSError *)postBoard:(NSDictionary *)boardDictionary WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)updateBoard:(DBBoard *)board withDictionary:(NSDictionary *)boardDictionary target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)deleteBoard:(DBBoard *)board WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)getBoardsForUser:(DBUser*)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
@end
