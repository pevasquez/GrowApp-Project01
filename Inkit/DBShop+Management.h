//
//  DBShop+Management.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//
#import "DBShop.h"


@interface DBShop (Management)
+ (void)createMockShopInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBShop *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBShop *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Get Shop
+ (NSArray *)getShopSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBShop *)fromJson: (NSDictionary *)jsonDictionary;

@end
