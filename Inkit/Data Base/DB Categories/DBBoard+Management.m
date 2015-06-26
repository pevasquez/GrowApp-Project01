//
//  DBBoard+Management.m
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBBoard+Management.h"
#import "InkitService.h"
#import "DataManager.h"
#import "NSDate+Extension.h"

#define kDBBoard     @"DBBoard"
NSString *const JSONBoardID = @"id";
NSString *const JSONBoardName = @"name";
NSString *const JSONBoardDescription = @"description";
NSString *const JSONBoardCreatedAt = @"created_at";
NSString *const JSONBoardUpdatedAt = @"updated_at";
NSString *const JSONBoardUser = @"owner";
NSString *const JSONBoardInksCount = @"inks_count";
NSString *const JSONBoardFollowersCount = @"followers_count";
NSString *const JSONBoardPreviewInks = @"preview_inks";
NSString *const JSONBoardExtraData = @"extra_data";

@implementation DBBoard (Management)
- (void)updateWithDictionary:(NSDictionary *)boardDictionary Target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    [InkitService updateBoard:self withDictionary:boardDictionary target:target completeAction:completeAction completeError:completeError];
}

- (void)deleteWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    [InkitService deleteBoard:self WithTarget:target completeAction:completeAction completeError:completeError];
}

- (void)getInksWithCompletion:(ServiceResponse)completion {
    if (self.inks.count > 0) {
        completion(nil,nil);
    }
    [InkitService getInksFromBoard:self withCompletion:completion];
}

- (NSArray *)getInksFromBoard {
    NSArray* inksArray = [self.inks allObjects];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:false];
    NSArray* descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray* sortedArray = [inksArray sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

- (void)addInkToBoard:(DBInk *)ink
{
    [self addInksObject:ink];
    [DataManager saveContext];
}

- (void)addInksToBoard:(NSArray *)inksArray
{
    for (DBInk* ink in inksArray) {
        [self addInkToBoard:ink];
    }
    [DataManager saveContext];
}

- (void)removeInkFromBoard:(DBInk *)ink
{
    [self removeInksObject:ink];
    [DataManager saveContext];
}

- (void)removeInksFromBoard:(NSArray *)inksArray
{
    for (DBInk* ink in inksArray) {
        [self removeInkFromBoard:ink];
    }
    [DataManager saveContext];
}

- (void)deleteBoard
{
    [[DataManager sharedInstance] deleteObject:self];
    [DataManager saveContext];
}

+ (DBBoard *)newBoard {
    DBBoard* board = (DBBoard *)[[DataManager sharedInstance] insert:kDBBoard];
    return board;
}

+ (DBBoard *)withID:(NSString *)boardID {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"boardID = %@",boardID];
    return (DBBoard *)[[DataManager sharedInstance] first:kDBBoard predicate:predicate sort:nil limit:1];
}

+ (DBBoard *)fromJson:(NSDictionary *)boardData
{
    NSString* boardID = [NSString stringWithFormat:@"%@",boardData[JSONBoardID]];
    DBBoard* obj = [DBBoard withID:boardID];
    DBBoard* board = nil;
    if (!obj) {
        board = [DBBoard newBoard];
    } else {
        board = obj;
    }
    [board updateWithJson:boardData];
    return board;
}

- (void)updateWithJson:(NSDictionary *)boardData
{
    [boardData enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        // Ignore the key / value pair if the value is NSNull.
        if ([value isEqual:[NSNull null]]) {
            return;
        }
        
        if ([key isEqualToString:JSONBoardID]) {
            self.boardID = [NSString stringWithFormat:@"%@",boardData[JSONBoardID]];
        }
        else if ([key isEqualToString:JSONBoardName]) {
            self.boardTitle = value;
        }
        else if ([key isEqualToString:JSONBoardDescription]) {
            self.boardDescription = value;
        }
        else if ([key isEqualToString:JSONBoardCreatedAt]) {
            self.createdAt = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONBoardUpdatedAt]) {
            self.updatedAt = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONBoardUser]) {
            self.user = [DBUser fromJson:value[@"data"]];
        }
        else if ([key isEqualToString:JSONBoardInksCount]) {
            
        }
        else if ([key isEqualToString:JSONBoardFollowersCount]) {
            
        }
        else if ([key isEqualToString:JSONBoardPreviewInks]) {
            NSDictionary* inksDictionary = value[@"data"];
            for (NSDictionary* inkDictionary in inksDictionary) {
                [self addInksObject:[DBInk fromJson:inkDictionary]];
            }
        }
        else if ([key isEqualToString:JSONBoardExtraData]) {
            
        }
    }];
}

- (void)updateInksWithJson:(NSDictionary *)jsonDictionary {
    // TODO: ver lógica para actualizar
    for (NSDictionary* inkDictionary in jsonDictionary) {
        [self addInksObject:[DBInk fromJson:inkDictionary]];
    }
}

@end
