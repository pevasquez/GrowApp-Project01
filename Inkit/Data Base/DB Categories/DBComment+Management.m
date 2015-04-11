//
//  DBComment+Management.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBComment+Management.h"
#import "DataManager.h"

#define kDBComment     @"DBComment"

@implementation DBComment (Management)
+ (DBComment *)createCommentWithText:(NSString *)text
{
    DBComment* comment = [DBComment createCommentInManagedObjectContext:[DataManager sharedInstance].managedObjectContext];
    comment.text = text;
    [DataManager saveContext];
    return comment;
}

+ (DBComment *)createCommentInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBComment* comment = [NSEntityDescription insertNewObjectForEntityForName:kDBComment inManagedObjectContext:managedObjectContext];
    [DataManager saveContext];
    return comment;
}

@end
