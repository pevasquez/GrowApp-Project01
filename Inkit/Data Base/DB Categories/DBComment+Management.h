//
//  DBComment+Management.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBComment.h"

@interface DBComment (Management)
+ (DBComment *)createCommentWithText:(NSString*)text;
+ (DBComment *)createCommentInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end
