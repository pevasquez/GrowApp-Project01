//
//  DBInk+Management.m
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBInk+Management.h"
#import "DataManager.h"
#import "InkitService.h"
#import "DBBodyPart+Management.h"
#import "DBBoard+Management.h"
#import "DBTattooType+Management.h"
#import "DBComment+Management.h"
#import "DBArtist+Management.h"
#import "DBImage+Management.h"
#import "DBShop+Management.h"
#import "DataManager.h"
#import "InkitServiceConstants.h"
#import "InkitConstants.h"
#import "NSDate+Extension.h"

#define kDBInk     @"DBInk"

@implementation DBInk (Management)
+ (DBInk *)inkWithInk:(DBInk *)ink
{
    DBInk* newInk = [DBInk newInk];
    newInk.inkID = ink.inkID;
    newInk.likesCount = ink.likesCount;
    newInk.createdAt = ink.createdAt;
    newInk.extraData = ink.extraData;
    newInk.inkDescription = ink.inkDescription;
    newInk.reInksCount = ink.reInksCount;
    newInk.updatedAt = ink.updatedAt;
    newInk.image = ink.image;
    newInk.artist = ink.artist;
    [newInk addBodyParts:ink.bodyParts];
    [newInk addTattooTypes:ink.tattooTypes];
    newInk.shop = ink.shop;
    newInk.board = ink.board;
    newInk.user = ink.user;
    return newInk;
}

+ (DBInk *)newInk {
    DBInk* ink = (DBInk *)[[DataManager sharedInstance] insert:kDBInk];
    ink.likesCount = @0;
    ink.reInksCount = @0;
    ink.inkDescription = @"";
    return ink;
}

+ (DBInk *)withID:(NSString *)inkID {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"inkID = %@",inkID];
    return (DBInk *)[[DataManager sharedInstance] first:kDBInk predicate:predicate sort:nil limit:1];
}

+ (DBInk *)fromJson:(NSDictionary *)inkData {
    NSString* inkID = [NSString stringWithFormat:@"%@",inkData[@"id"]];
    DBInk* obj = [DBInk withID:inkID];
    DBInk* ink = nil;
    if (!obj) {
        ink = [DBInk newInk];
    } else {
        ink = obj;
    }
    [ink updateWithJson:inkData];
    [DataManager saveContext];
    return ink;
}

- (void)updateWithJson:(NSDictionary *)inkData {
    if ([inkData objectForKey:@"id"]) {
        self.inkID = [NSString stringWithFormat:@"%@",inkData[@"id"]];
    }
    if ([inkData objectForKey:@"description"]) {
        self.inkDescription = inkData[@"description"];
    }
    if ([inkData objectForKey:@"image_path"]) {
        NSString* imagePath = inkData[@"image_path"];
        NSString* pathExtension = imagePath.pathExtension;
        NSString* path = [imagePath substringToIndex:(imagePath.length - pathExtension.length - 1)];
        NSString* scale = @"";
        switch ((int)[UIScreen mainScreen].scale) {
            case 2:
                scale = @"@2x";
                break;
            case 3:
                scale = @"@3x";
                break;
            default:
                break;
        }
        self.image = [DBImage fromURL:imagePath];
        //        self.thumbnailImage = [DBImage fromURL:[NSString stringWithFormat:@"%@_160%@.%@",path,scale,pathExtension]];
        //        self.fullScreenImage = [DBImage fromURL:[NSString stringWithFormat:@"%@_320%@.%@",path,scale,pathExtension]];
        NSString* thumbnailString = [NSString stringWithFormat:@"%@_160%@.jpg",path,scale];
        self.thumbnailImage = [DBImage fromURL:thumbnailString];
        self.fullScreenImage = [DBImage fromURL:[NSString stringWithFormat:@"%@_320%@.jpg",path,scale]];
    }
    if ([inkData objectForKey:@"user"]) {
        self.user = [DBUser fromJson:inkData[@"user"][@"data"]];
    }
    if ([inkData objectForKey:@"created_at"]) {
        self.createdAt = [NSDate fromUnixTimeStamp:inkData[@"created_at"]];
    }
    if ([inkData objectForKey:@"updated_at"]) {
        self.updatedAt = [NSDate fromUnixTimeStamp:inkData[@"created_at"]];
    }
    if ([inkData objectForKey:@"likes_count"] && !([inkData objectForKey:@"likes_count"] == [NSNull null])) {
        self.likesCount = inkData[@"likes_count"];
    }
    if ([inkData objectForKey:@"reinks_count"] && !([inkData objectForKey:@"reinks_count"] == [NSNull null])) {
        self.reInksCount = inkData[@"reinks_count"];
    }
    if ([inkData objectForKey:@"board"]) {
        self.board = [DBBoard fromJson:inkData[@"board"][@"data"]];
    }
    if ([inkData objectForKey:@"extra_data"]) {
        NSDictionary* extraData = inkData[@"extra_data"];
        if ([extraData objectForKey:@"logged_user_likes"]) {
            self.loggedUserLikes = extraData[@"logged_user_likes"];
        }
        if ([extraData objectForKey:@"logged_user_reinked"]) {
            self.loggedUserReInked = extraData[@"logged_user_reinked"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DBNotificationInkUpdate object:nil userInfo:@{kDBInk:self}];
}

- (UIImage *)getInkImage
{
    UIImage* inkImage = [UIImage imageWithData:self.image.imageData];
    return inkImage;
}

- (NSString *)getBodyPartsAsString
{
    NSString* bodyParts = @"";
    for (DBBodyPart* bodyPart in self.bodyParts) {
        bodyParts = [bodyParts stringByAppendingString:[NSString stringWithFormat:@"%@ ",bodyPart.name]];
    }
    return bodyParts;
}

- (NSString *)getTattooTypesAsString
{
    NSString* tattooTypes = @"";
    for (DBTattooType* tattooType in self.tattooTypes) {
        tattooTypes = [tattooTypes stringByAppendingString:[NSString stringWithFormat:@"%@ ",tattooType.name]];
    }
    return tattooTypes;
}

- (NSString *)getArtistsAsString
{
    return self.artist.name;
}


- (void)updateWithInk:(DBInk *)ink
{
    self.inkID = ink.inkID;
    self.likesCount = ink.likesCount;
    self.createdAt = ink.createdAt;
    self.extraData = ink.extraData;
    self.inkDescription = ink.inkDescription;
    self.reInksCount = ink.reInksCount;
    self.updatedAt = ink.updatedAt;
    self.image = ink.image;
    self.artist = ink.artist;
    [self addBodyParts:ink.bodyParts];
    [self addTattooTypes:ink.tattooTypes];
    self.shop = ink.shop;
    self.board = ink.board;
    self.user = ink.user;
}

+ (void)deleteInk:(DBInk *)ink completion:(ServiceResponse)completion {
    [InkitService deleteInk:ink completion:^(id response, NSError *error) {
        if (error == nil) {
            [[DataManager sharedInstance] deleteObject:ink];
        }
        completion(response, error);
    }];
}

- (NSArray *)getCommentsSorted {
    NSArray* comments = self.comments.allObjects;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"commentDate" ascending: NO];
    NSArray *sortedArray = [comments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return sortedArray;
}

- (void)updateCommentsWithJson:(NSArray *)commentsArray {
    for (NSDictionary* commentDictionary in commentsArray) {
        [self addCommentsObject:[DBComment fromJson:commentDictionary]];
    }
}

- (NSArray *)toArray
{
    return @[];
}

- (NSDictionary *)toDictionary
{
    NSArray* bodyParts = self.bodyParts.allObjects;
    NSArray* tattooTypes = self.tattooTypes.allObjects;
    NSMutableDictionary* inkData = [@{kInkDescription:self.inkDescription,
                                     kInkBoard:self.board,
                                     kInkImage:self.image} mutableCopy];
    if ([bodyParts count]) {
        inkData[kInkBodyParts] = bodyParts;
    }
    if ([tattooTypes count]) {
        inkData[kInkTattooTypes] = tattooTypes;
    }
    if (self.artist) {
        inkData[kInkArtist] = self.artist;
    }
    if (self.shop) {
        inkData[kInkShop] = self.shop;
    }
    return inkData;
}

+ (NSDictionary *)emptyDictionary
{
    return @{kInkDescription:@"",
             kInkBoard:@"",
             kInkImage:@"",
             kInkTattooTypes:@[],
             kInkBodyParts:@[]
             };
}
@end
