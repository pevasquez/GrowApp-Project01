//
//  DBUser+Management.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBUser+Management.h"
#import "DBBoard+Management.h"
#import "DBImage+Management.h"
#import "InkitService.h"
#import "InkitDataUtil.h"
#import "DataManager.h"

#define kDBUser     @"DBUser"
#define kBoardTitle @"boardTitle"

@implementation DBUser (Management)
+ (DBUser *)createNewUser
{
    DBUser* user = [DBUser createInManagedObjectContext:[DataManager sharedInstance].managedObjectContext];
    user.firstName = @"";
    user.lastName = @"";
    user.email = @"";
    user.password = @"";
    
    return user;
}

+ (DBUser *)fromJson:(NSDictionary *)userData
{
    DBUser* user = [DBUser createInManagedObjectContext:[DataManager sharedInstance].managedObjectContext];
    
    if ([userData objectForKey:@"id"]) {
        user.userID = userData[@"id"];
    }
    if ([userData objectForKey:@"profile_pic"]) {
        user.profilePic = [DBImage fromURL:userData[@"profile_pic"]];
    }
    if ([userData objectForKey:@"profile_pic_thumbnail"]) {
        user.profilePicThumbnail = [DBImage fromURL:userData[@"profile_pic_thumbnail"]];
    }
    if ([userData objectForKey:@"first_name"]) {
        user.firstName = userData[@"first_name"];
    }
    if ([userData objectForKey:@"last_name"]) {
        user.lastName = userData[@"last_name"];
    }
    if ([userData objectForKey:@"full_name"]) {
        user.fullName = userData[@"full_name"];
    }
    if ([userData objectForKey:@"profile_url"]) {
        user.profileURL = userData[@"profile_url"];
    }
//    if ([userData objectForKey:@"created_at"]) {
//        user.createdAt = userData[@"created_at"];
//    }
//    if ([userData objectForKey:@"updated_at"]) {
//        user.updatedAt = userData[@"updated_at"];
//    }
    return user;
}

/*"user": {
    "data": {
        "type": "User",
        "id": 9,
        "profile_pic": "http://inkit.digbang.com/assets/frontend/img/user_default.png",
        "profile_pic_thumbnail": "http://inkit.digbang.com/assets/frontend/img/user_default_thumbnail.png",
        "first_name": "Dario",
        "last_name": "Govergun",
        "full_name": "Dario Govergun",
        "profile_url": "dgovergun",
        "created_at": 1424797742,
        "updated_at": 1425322833
    }
},*/

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

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"First Name:%@\nToken:%@",self.firstName,self.token];
//}

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
