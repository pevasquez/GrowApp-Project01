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
#import "InkitServiceConstants.h"
#import "InkitConstants.h"

#define kDBBoard     @"DBBoard"

@implementation DBBoard (Management)
+ (NSArray *)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDBBoard];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kBoardTitle ascending:YES]];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray* boards = [[NSMutableArray alloc] init];
    
    if ([matches count]&&!error) {
        for (DBBoard* board in matches) {
            [boards addObject:board];
        }
        return boards;
    } else {
        return nil;
    }
}

- (void)updateWithDictionary:(NSDictionary *)boardDictionary Target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    [InkitService updateBoard:self withDictionary:boardDictionary target:target completeAction:completeAction completeError:completeError];
}

- (void)deleteWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    [InkitService deleteBoard:self WithTarget:target completeAction:completeAction completeError:completeError];
}


- (NSArray *)getInksFromBoard
{
    NSArray* inksArray = [self.inks allObjects];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"inkDescription" ascending:YES];
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

//
+ (DBBoard *)withID:(NSString *)boardID
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"boardID = %@",boardID];
    return (DBBoard *)[[DataManager sharedInstance] first:kDBBoard predicate:predicate sort:nil limit:1];
}

+ (DBBoard *)fromJson:(NSDictionary *)boardData
{
    NSString* boardID = [NSString stringWithFormat:@"%@",boardData[@"id"]];
    DBBoard* obj = [DBBoard withID:boardID];
    DBBoard* board = nil;
    if (!obj) {
        board = (DBBoard *)[[DataManager sharedInstance] insert:kDBBoard];
    } else {
        board = obj;
    }
    [board updateWithJson:boardData];
    [DataManager saveContext];
    return board;
}

- (void)updateWithJson:(NSDictionary *)jsonDictionary
{
    if ([jsonDictionary objectForKey:@"id"]) {
        self.boardID = [NSString stringWithFormat:@"%@",jsonDictionary[@"id"]];
    }
    if ([jsonDictionary objectForKey:@"name"]) {
        self.boardTitle = jsonDictionary[@"name"];
    }
    if ([jsonDictionary objectForKey:@"description"]) {
        self.boardDescription = jsonDictionary[@"description"];
    }
    if ([jsonDictionary objectForKey:@"created_at"]) {
        //
    }
    if ([jsonDictionary objectForKey:@"extra_data"]) {
        //
    }
    if ([jsonDictionary objectForKey:@"followers_count"]) {
        //
    }
    if ([jsonDictionary objectForKey:@"inks_count"]) {
        //
    }
    if ([jsonDictionary objectForKey:@"owner"]) {
        NSDictionary* userDictionary = jsonDictionary[@"owner"][@"data"];
        self.user = [DBUser fromJson:userDictionary];
    }
    if ([jsonDictionary objectForKey:@"preview_inks"]) {
        NSDictionary* inksDictionary = jsonDictionary[@"preview_inks"][@"data"];
        for (NSDictionary* inkDictionary in inksDictionary) {
            [self addInksObject:[DBInk fromJson:inkDictionary]];
        }
    }
    if ([jsonDictionary objectForKey:@"updated_at"]) {
        //
    }
}

@end
