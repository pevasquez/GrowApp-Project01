//
//  DBComment+Management.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBComment+Management.h"

#define kDBComment     @"DBComment"

@implementation DBComment (Management)
+ (DBComment *)createCommentWithText:(NSString*)text inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBComment* comment = [NSEntityDescription insertNewObjectForEntityForName:kDBComment inManagedObjectContext:managedObjectContext];
    comment.text = text;
    return comment;
}

@end
