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


#define kDBBoard     @"DBBoard"
#define kBoardTitle     @"boardTitle"

@implementation DBBoard (Management)
+ (DBBoard *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBBoard* board = [NSEntityDescription insertNewObjectForEntityForName:kDBBoard inManagedObjectContext:managedObjectContext];
    return board;
}

+ (DBBoard *)createWithTitle:(NSString *)boardTitle AndDescription:(NSString *)boardDescription InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBBoard* board = [DBBoard createInManagedObjectContext:managedObjectContext];
    board.boardDescription = boardDescription;
    board.boardTitle = boardTitle;
    
    // Save context
    NSError* error = nil;
    [managedObjectContext save:&error];
    
    return board;
}

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

+ (void)getBoardsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    if ([DBBoard getBoardsInManagedObjectContext:managedObjectContext]) {
        [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    } else {
        [InkitService getBoardsWithTarget:target completeAction:completeAction completeError:completeError];
    }
}

- (void)postWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    [InkitService postBoard:self WithTarget:target completeAction:completeAction completeError:completeError];
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
    
    [self saveManagedObjectContext];
}

- (void)addInksToBoard:(NSArray *)inksArray
{
    for (DBInk* ink in inksArray) {
        [self addInkToBoard:ink];
    }
    [self saveManagedObjectContext];
}

- (DBInk *)createInkWithImage:(UIImage *)image AndDescription:(NSString *)description
{
    DBInk* ink = [DBInk createWithImage:image AndDescription:description InManagedObjectContext:self.managedObjectContext];
    [self addInksObject:ink];
    // Save context
    NSError* error = nil;
    [self.managedObjectContext save:&error];
    return ink;
}

- (void)removeInkFromBoard:(DBInk *)ink
{
    [self removeInksObject:ink];
    [self saveManagedObjectContext];
}

- (void)removeInksFromBoard:(NSArray *)inksArray
{
    for (DBInk* ink in inksArray) {
        [self removeInkFromBoard:ink];
    }
    [self saveManagedObjectContext];
}

- (void)deleteBoard
{
    [self.managedObjectContext deleteObject:self];
    [self saveManagedObjectContext];
}
- (void)saveManagedObjectContext
{
    // Save context
    NSError* error = nil;
    [self.managedObjectContext save:&error];
}


+ (DBBoard *)fromJson:(NSDictionary *)boardData
{
    DBBoard* board = [DBBoard createInManagedObjectContext:[DataManager sharedInstance].managedObjectContext];
    
    if ([boardData objectForKey:@"id"]) {
        board.boardID = boardData[@"id"];
    }
    if ([boardData objectForKey:@"name"]) {
        board.boardTitle = boardData[@"name"];
    }
    return board;
}
@end
