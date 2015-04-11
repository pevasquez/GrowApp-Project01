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
    DBUser* user = [DBUser createNewUser];
    
    [user updateWithJson:userData];
    return user;
}

- (void)updateWithJson:(NSDictionary *)jsonDictionary
{
    if ([jsonDictionary objectForKey:@"styles"])
        self.styles = jsonDictionary[@"styles"];
    if ([jsonDictionary objectForKey:@"id"])
        self.userID = jsonDictionary[@"id"];
    if ([jsonDictionary objectForKey:@"type"])
        self.type = jsonDictionary[@"type"];
    if ([jsonDictionary objectForKey:@"country"])
        self.country = jsonDictionary[@"country"];
    if ([jsonDictionary objectForKey:@"gender"])
        self.gender = jsonDictionary[@"gender"];
    if ([jsonDictionary objectForKey:@"city"])
        self.city = jsonDictionary[@"city"];
    if ([jsonDictionary objectForKey:@"email"])
        self.email = jsonDictionary[@"email"];
    if ([jsonDictionary objectForKey:@"profile_pic"])
        self.profilePic = [DBImage fromURL:jsonDictionary[@"profile_pic"]];
    if ([jsonDictionary objectForKey:@"profile_pic_thumbnail"])
        self.profilePicThumbnail = [DBImage fromURL:jsonDictionary[@"profile_pic_thumbnail"]];
    if ([jsonDictionary objectForKey:@"first_name"])
        self.firstName = jsonDictionary[@"first_name"];
    if ([jsonDictionary objectForKey:@"last_name"])
        self.lastName = jsonDictionary[@"last_name"];
    if ([jsonDictionary objectForKey:@"full_name"])
        self.fullName = jsonDictionary[@"full_name"];
    if ([jsonDictionary objectForKey:@"name"])
        self.fullName = jsonDictionary[@"name"];
    if ([jsonDictionary objectForKey:@"profile_url"])
        self.profileURL = jsonDictionary[@"profile_url"];
    if ([jsonDictionary objectForKey:@"created_at"])
        self.createdAt = jsonDictionary[@"created_at"];
    if ([jsonDictionary objectForKey:@"updated_at"])
        self.updatedAt = jsonDictionary[@"updated_at"];
    if ([jsonDictionary objectForKey:@"default_language"])
        self.defaultLanguage = jsonDictionary[@"default_language"];
    if ([jsonDictionary objectForKey:@"artist_shop_data"])
        self.artistShopData = jsonDictionary[@"artist_shop_data"];
    if ([jsonDictionary objectForKey:@"inks_liked_counts"])
        self.inksLikedCount = jsonDictionary[@"inks_liked_counts"];
    if ([jsonDictionary objectForKey:@"followers_count"])
        self.followersCount = jsonDictionary[@"followers_count"];
    if ([jsonDictionary objectForKey:@"boards_count"])
        self.boardsCount = jsonDictionary[@"boards_count"];
    if ([jsonDictionary objectForKey:@"social_networks"])
        self.socialNetworks = jsonDictionary[@"social_networks"];
    if ([jsonDictionary objectForKey:@"artists"])
        self.artists = jsonDictionary[@"artists"];
    if ([jsonDictionary objectForKey:@"shops"])
        self.shops = jsonDictionary[@"shops"];
    if ([jsonDictionary objectForKey:@"tattoo_types"])
        self.tattooTypes = jsonDictionary[@"tattoo_types"];
}


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
    DBBoard* board = [DBBoard createWithTitle:title AndDescription:description];
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
