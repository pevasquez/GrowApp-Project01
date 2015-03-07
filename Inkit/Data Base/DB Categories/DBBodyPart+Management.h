//
//  DBBodyParts+Management.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBBodyPart.h"

@interface DBBodyPart (Management)
+ (DBBodyPart *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBBodyPart *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Get Body Parts
+ (NSArray *)getBodyPartsSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Mock Methods
+ (void)createMockBodyPartsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end
