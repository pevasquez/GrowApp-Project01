//
//  DBComment+Management.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBComment+Management.h"
#import "NSDate+Extension.h"
#import "DataManager.h"


#define kDBComment     @"DBComment"
NSString *const JSONCommentID = @"id";
NSString *const JSONCommentComment = @"comment";
NSString *const JSONCommentCreatedAt = @"created_at";
NSString *const JSONCommentUser = @"user";

@implementation DBComment (Management)
+ (DBComment *)newComment {
    DBComment *comment = (DBComment *)[[DataManager sharedInstance] insert:kDBComment];
    
    return comment;
}

+ (DBComment *)withID:(NSString *)commentID {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"commentID = %@",commentID];
    return (DBComment *)[[DataManager sharedInstance] first:kDBComment predicate:predicate sort:nil limit:1];
}

+ (DBComment *)fromJson:(NSDictionary *)commentData {
    NSString* commentID = [NSString stringWithFormat:@"%@",commentData[JSONCommentID]];
    DBComment* obj = [DBComment withID:commentID];
    DBComment* comment = nil;
    if (!obj) {
        comment = [DBComment newComment];
    } else {
        comment = obj;
    }
    [comment updateWithJson:commentData];
    return comment;
}

- (void)updateWithJson:(NSDictionary *)commentData {
    [commentData enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        // Ignore the key / value pair if the value is NSNull.
        if ([value isEqual:[NSNull null]]) {
            return;
        }
        
        if ([key isEqualToString:JSONCommentID]) {
            self.commentID = [NSString stringWithFormat:@"%@",commentData[JSONCommentID]];
        }
        else if ([key isEqualToString:JSONCommentComment]) {
            self.text = value;
        }
        else if ([key isEqualToString:JSONCommentCreatedAt]) {
            self.commentDate = [NSDate fromUnixTimeStamp:value];
        }
        else if ([key isEqualToString:JSONCommentUser]) {
            self.user = [DBUser fromJson:value[@"data"]];
        }
    }];
}

@end
