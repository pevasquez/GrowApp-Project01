//
//  DBShop+Management.h
//  Inkit
//
//  Created by Cristian Pena on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//
#import "DBShop.h"


@interface DBShop (Management)
// Get Shop
+ (NSArray *)getShopSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBShop *)fromJson: (NSDictionary *)jsonDictionary;

@end
