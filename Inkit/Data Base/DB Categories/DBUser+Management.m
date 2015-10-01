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

#define kDBUser     @"DBUser"
NSString *const JSONUserStyles = @"styles";
NSString *const JSONUserCountry = @"country";
NSString *const JSONUserGender = @"gender";
NSString *const JSONUserCity = @"city";
NSString *const JSONUserEmail = @"email";
NSString *const JSONUserProfilePic = @"profile_pic";
NSString *const JSONUserProfilePicThumbnail = @"profile_pic_thumbnail";
NSString *const JSONUserFirstName = @"first_name";
NSString *const JSONUserLastName = @"last_name";
NSString *const JSONUserFullName = @"full_name";
NSString *const JSONUserName = @"name";
NSString *const JSONUserProfileUrl = @"profile_url";
NSString *const JSONUserCreatedAt = @"created_at";
NSString *const JSONUserUpdatedAt = @"updated_at";
NSString *const JSONUserDefaultLanguage = @"default_language";
NSString *const JSONUserArtistShopData = @"artist_shop_data";
NSString *const JSONUserInksLikedCounts = @"inks_liked_counts";
NSString *const JSONUserFollowersCount = @"followers_count";
NSString *const JSONUserBoardsCount = @"boards_count";
NSString *const JSONUserSocialNetworks = @"social_networks";
NSString *const JSONUserAccessToken = @"access_token";
NSString *const JSONUserAccessTokenType = @"token_type";
NSString *const JSONUserAccessTokenExpiresIn = @"expires_in";

@implementation DBUser (Management)
+ (DBUser *)newUser {
    DBUser* user = (DBUser *)[[DataManager sharedInstance] insert:kDBUser];
    user.firstName = @"";
    user.lastName = @"";
    user.email = @"";
    user.password = @"";
    
    return user;
}

+ (DBUser *)withID:(NSString *)userID {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"userID = %@",userID];
    return (DBUser *)[[DataManager sharedInstance] first:kDBUser predicate:predicate sort:nil limit:20];
}

+ (DBUser *)fromJson:(NSDictionary *)userData {
    NSString* userID = nil;
    if ([userData objectForKey:kUserID]) {
        userID = [NSString stringWithFormat:@"%@",userData[kUserID]];
    } else if ([userData objectForKey:kAccessToken]) {
        userID = [NSString stringWithFormat:@"%@",userData[kAccessToken]];
    } else {
        return nil;
    }
    DBUser* obj = [DBUser withID:userID];
    DBUser* user = nil;
    if (!obj) {
        user = [DBUser newUser];
    } else {
        user = obj;
    }
    [user updateWithJson:userData];
    return user;
}

- (void)updateWithJson:(NSDictionary *)JSONUserDictionary {
    [JSONUserDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        // Ignore the key / value pair if the value is NSNull.

        if ([value isEqual:[NSNull null]]) {
            return;
        }
        
        if ([key isEqualToString:JSONUserStyles]) {
            self.styles = value;
        }
        else if ([key isEqualToString:JSONUserCountry]) {
            self.country = value;
        }
        else if ([key isEqualToString:JSONUserGender]) {
            self.gender = value;
        }
        else if ([key isEqualToString:JSONUserCity]) {
            self.city = value;
        }
        else if ([key isEqualToString:JSONUserEmail]) {
            self.email = value;
        }
        else if ([key isEqualToString:JSONUserProfilePic]) {
            self.profilePic = [DBImage fromURL:JSONUserDictionary[@"profile_pic"]];
        }
        else if ([key isEqualToString:JSONUserProfilePicThumbnail]) {
            self.profilePicThumbnail = [DBImage fromURL:JSONUserDictionary[@"profile_pic_thumbnail"]];
        }
        else if ([key isEqualToString:JSONUserFirstName]) {
            self.firstName = value;
        }
        else if ([key isEqualToString:JSONUserLastName]) {
            self.lastName = value;
        }
        else if ([key isEqualToString:JSONUserFullName]) {
            self.fullName = value;
        }
        else if ([key isEqualToString:JSONUserName]) {
            self.name = value;
        }
        else if ([key isEqualToString:JSONUserProfileUrl]) {
            self.profileURL = value;
        }
        else if ([key isEqualToString:JSONUserCreatedAt]) {
            self.createdAt = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONUserUpdatedAt]) {
            self.updatedAt = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONUserDefaultLanguage]) {
            self.defaultLanguage = value;
        }
        else if ([key isEqualToString:JSONUserArtistShopData]) {
            self.artistShopData = value;
        }
        else if ([key isEqualToString:JSONUserInksLikedCounts]) {
            self.inksLikedCount = value;
        }
        else if ([key isEqualToString:JSONUserFollowersCount]) {
            self.followersCount = value;
        }
        else if ([key isEqualToString:JSONUserBoardsCount]) {
            self.boardsCount = value;
        }
        else if ([key isEqualToString:JSONUserSocialNetworks]) {
            self.socialNetworks = value;
        }
        else if ([key isEqualToString:JSONUserAccessToken]) {
            self.token = [NSString stringWithFormat:@"%@",value];
            self.userID = [NSString stringWithFormat:@"%@",value];
        }
        else if ([key isEqualToString:JSONUserAccessTokenType]) {
            self.tokenType = value;
        }
        else if ([key isEqualToString:JSONUserAccessTokenExpiresIn]) {
            self.expiresIn = value;
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DBNotificationUserUpdate object:nil userInfo:@{kDBUser:self}];
}

- (DBBoard *)createBoardFromJson:(NSDictionary *)boardDictionary {
    DBBoard* board = [DBBoard fromJson:boardDictionary];
    board.user = self;
    return board;
}

- (void)getBoardsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError {
    if ([self getSortedBoards]) {
        [target performSelectorOnMainThread:completeAction withObject:nil waitUntilDone:NO];
    }
    [InkitService getBoardsForUser:self withTarget:target completeAction:completeAction completeError:completeError];
}

- (NSArray *)getSortedBoards {
    NSArray* boardsArray = [self.boards.array copy];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"boardTitle" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray* descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray* sortedArray = [boardsArray sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

@end
