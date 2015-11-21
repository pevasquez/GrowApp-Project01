//
//  IKBoard.m
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import "IKBoard.h"
#import "IKInk.h"
#import "IKImage.h"

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

@implementation IKBoard

+ (IKBoard *)newBoard {
    IKBoard* board = [IKBoard new];
    return board;
}

+ (IKBoard *)fromJson:(NSDictionary *)boardData {
    IKBoard* board = [IKBoard newBoard];
    [board updateWithJson:boardData];
    return board;
}

- (void)updateWithJson:(NSDictionary *)boardData {
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
                IKInk *ink = [IKInk fromJson:inkDictionary];
                if (![self containInk:ink]) {
                    [self.inks addObject:ink];
                }
            }
        }
        else if ([key isEqualToString:JSONBoardExtraData]) {
            
        }
    }];
}

- (BOOL)containInk:(IKInk *)newInk {
    for (IKInk *ink in self.inks) {
        if ([ink.inkID isEqualToString:newInk.inkID]) {
            return true;
        }
    }
    return false;
}

- (void)getInksWithCompletion:(ServiceResponse)completion {
    if (self.inks.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([self getInksFromBoard],nil);
        });
    }
    [InkitService getInksFromBoard:self withCompletion:completion];
}

- (NSArray *)getInksFromBoard {
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:false];
    NSArray* descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray* sortedArray = [self.inks sortedArrayUsingDescriptors:descriptors];
    return sortedArray;
}

@end
