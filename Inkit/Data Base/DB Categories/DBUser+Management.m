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
#import "InkitConstants.h"
#import "DataManager.h"
#import "NSDate+Extension.h"

#define kDBUser     @"DBUser"

@implementation DBUser (Management)
+ (DBUser *)createNewUser
{
    
    DBUser* user = (DBUser *)[[DataManager sharedInstance] insert:kDBUser];
    user.firstName = @"";
    user.lastName = @"";
    user.email = @"";
    user.password = @"";
    
    return user;
}

+ (DBUser *)withID:(NSString *)userID
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userID = %@",userID];
    return (DBUser *)[[DataManager sharedInstance] first:kDBUser predicate:predicate sort:nil limit:1];
}

+ (DBUser *)fromJson:(NSDictionary *)userData
{
    NSString* userID = [NSString stringWithFormat:@"%@",userData[kUserID]] ;
    DBUser* obj = [DBUser withID:userID];
    DBUser* user = nil;
    if (!obj) {
        user = (DBUser *)[[DataManager sharedInstance] insert:kDBUser];
    } else {
        user = obj;
    }
    [user updateWithJson:userData];
    [DataManager saveContext];
    return user;
}

- (void)updateWithJson:(NSDictionary *)jsonDictionary
{
    if ([jsonDictionary objectForKey:@"styles"])
        self.styles = jsonDictionary[@"styles"];
    if ([jsonDictionary objectForKey:kUserID])
        self.userID = [NSString stringWithFormat:@"%@",jsonDictionary[kUserID]];
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
    if ([jsonDictionary objectForKey:@"created_at"]){
        self.createdAt = [NSDate fromUnixTimeStamp:jsonDictionary[@"created_at"]];
    }
    if ([jsonDictionary objectForKey:@"updated_at"]) {
        self.updatedAt = [NSDate fromUnixTimeStamp:jsonDictionary[@"created_at"]];
    }
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
    if ([jsonDictionary objectForKey:kAccessToken]) {
        self.token = [NSString stringWithFormat:@"%@",[jsonDictionary objectForKey:kAccessToken]];
        self.userID = [NSString stringWithFormat:@"%@",[jsonDictionary objectForKey:kAccessToken]];
    }
//    if ([jsonDictionary objectForKey:@"artists"])
//        self.artists = jsonDictionary[@"artists"];
//    if ([jsonDictionary objectForKey:@"shops"])
//        self.shops = jsonDictionary[@"shops"];
//    if ([jsonDictionary objectForKey:@"tattoo_types"])
//        self.tattooTypes = jsonDictionary[@"tattoo_types"];
    [[NSNotificationCenter defaultCenter] postNotificationName:DBNotificationUserUpdate object:nil userInfo:@{kDBUser:self}];
}

- (DBBoard *)createBoardFromJson:(NSDictionary *)boardDictionary
{
    DBBoard* board = [DBBoard fromJson:boardDictionary];
    board.user = self;
    return board;
}

- (void)getBoardsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError
{
    if ([self getSortedBoards]) {
        [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    }
    [InkitService getBoardsForUser:self withTarget:target completeAction:completeAction completeError:completeError];
}

- (NSArray *)getSortedBoards
{
    NSArray* boardsArray = [self.boards.array copy];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"boardTitle" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray* descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray* sortedArray = [boardsArray sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

@end
