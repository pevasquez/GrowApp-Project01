//
//  IKInk.m
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import "IKInk.h"
#import "IKBoard.h"
#import "IKImage.h"

NSString *const JSONInkID = @"id";
NSString *const JSONInkImage = @"image_path";
NSString *const JSONInkDescription = @"description";
NSString *const JSONInkCreatedAt = @"created_at";
NSString *const JSONInkUpdatedAt = @"updated_at";
NSString *const JSONInkUser = @"user";
NSString *const JSONInkCommentsCount = @"comments_count";
NSString *const JSONInkLikesCount = @"likes_count";
NSString *const JSONInkReInksCount = @"reinks_count";
NSString *const JSONInkBoard = @"board";
NSString *const JSONInkExtraData = @"extra_data";
NSString *const JSONInkLoggedUserLikes = @"logged_user_likes";
NSString *const JSONInkLoggedUserReInked = @"logged_user_reinked";

@implementation IKInk

+ (IKInk *)newInk {
    IKInk* ink = [IKInk new];
    ink.likesCount = @0;
    ink.reInksCount = @0;
    ink.inkDescription = @"";
    return ink;
}

+ (IKInk *)fromJson:(NSDictionary *)inkData {
    IKInk* ink = [IKInk newInk];
    [ink updateWithJson:inkData];
    return ink;
}

- (void)updateWithJson:(NSDictionary *)inkData {
    [inkData enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        // Ignore the key / value pair if the value is NSNull.
        if ([value isEqual:[NSNull null]]) {
            return;
        }
        
        if ([key isEqualToString:JSONInkID]) {
            self.inkID = [NSString stringWithFormat:@"%@",inkData[JSONInkID]];
        }
        else if ([key isEqualToString:JSONInkDescription]) {
            self.inkDescription = value;
        }
        else if ([key isEqualToString:JSONInkCreatedAt]) {
            self.createdAt = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONInkUpdatedAt]) {
            self.updatedAt = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONInkUser]) {
            self.user = [DBUser fromJson:value[@"data"]];
        }
        else if ([key isEqualToString:JSONInkLikesCount]) {
            self.likesCount = value;
        }
        else if ([key isEqualToString:JSONInkReInksCount]) {
            self.reInksCount = value;
        }
        else if ([key isEqualToString:JSONInkCommentsCount]) {
            self.commentsCount = value;
        }
        else if ([key isEqualToString:JSONInkBoard]) {
            self.board = [IKBoard fromJson:value[@"data"]];
        }
        else if ([key isEqualToString:JSONInkImage]) {
            NSString* imagePath = value;
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
            self.image = [IKImage fromURL:imagePath];
            NSString* thumbnailString = [NSString stringWithFormat:@"%@_160%@.jpg",path,scale];
            self.thumbnailImage = [IKImage fromURL:thumbnailString];
            self.fullScreenImage = [IKImage fromURL:[NSString stringWithFormat:@"%@_320%@.jpg",path,scale]];
        }
        else if ([key isEqualToString:JSONInkExtraData]) {
            NSDictionary* extraData = (NSDictionary *)value;
            [extraData enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
                // Ignore the key / value pair if the value is NSNull.
                if ([value isEqual:[NSNull null]]) {
                    return;
                }
                
                if ([key isEqualToString:JSONInkLoggedUserLikes]) {
                    self.loggedUserLikes = value;
                }
                else if ([key isEqualToString:JSONInkLoggedUserReInked]) {
                    self.loggedUserReInked = value;
                }
            }];
        }
    }];
}

@end
