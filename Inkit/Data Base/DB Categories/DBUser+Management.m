//
//  DBUser+Management.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBUser+Management.h"
#import "DBBoard+Management.h"
#import "InkitService.h"
#import "InkitDataUtil.h"

#define kDBUser     @"DBUser"
#define kBoardTitle @"boardTitle"

@implementation DBUser (Management)
+ (DBUser *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBUser* user = [NSEntityDescription insertNewObjectForEntityForName:kDBUser inManagedObjectContext:managedObjectContext];
    return user;
}

+ (DBUser *)createMockUserInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBUser* user = [NSEntityDescription insertNewObjectForEntityForName:kDBUser inManagedObjectContext:managedObjectContext];
    user.firstName = @"Cristian";
    user.lastName = @"Pena";
    user.name = @"Cristian Pena";
    user.birthday = @"30/08/1984";
    user.email = @"cpena@digbang.com";
    user.userImage = UIImageJPEGRepresentation([UIImage imageNamed:@"Cristian con clase.jpg"],0.9);
    
    // Save context
    NSError* error = nil;
    [managedObjectContext save:&error];

    return user;
}

- (DBBoard *)createBoardWithTitle:(NSString *)title AndDescription:(NSString *)description
{
    DBBoard* board = [DBBoard createWithTitle:title AndDescription:description InManagedObjectContext:self.managedObjectContext];
    board.user = self;
    // Save context
    NSError* error = nil;
    [self.managedObjectContext save:&error];
    
    return board;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"First Name:%@\nToken:%@",self.firstName,self.token];
}

- (void)getBoardsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    if ([self getBoards]) {
        [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    } else {
        [InkitService getBoardsWithTarget:target completeAction:completeAction completeError:completeError];
    }
}

- (NSArray *)getBoards
{
    NSArray* boardsArray = self.boards.array;
    //NSArray* boardsArray = [DBBoard getBoardsInManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:kBoardTitle ascending:YES];
    NSArray* descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray* sortedArray = [boardsArray sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

@end
