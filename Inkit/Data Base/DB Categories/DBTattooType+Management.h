//
//  DBTattooType+Management.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 6/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBTattooType.h"

@interface DBTattooType (Management)
+ (void)createMockTattooTypesInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBTattooType *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBTattooType *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Get Body Parts
+ (NSArray *)getTattooTypeSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end
