//
//  DBShop+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBShop+Management.h"

@implementation DBShop (Management)


#define kDBShop @"DBShop"
#define kDBShopName @"name"

+ (DBShop *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBShop* shop = [NSEntityDescription insertNewObjectForEntityForName:kDBShop
                                                     inManagedObjectContext:managedObjectContext];
    return shop;
}

+ (DBShop *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBShop* shop = [DBShop createInManagedObjectContext:managedObjectContext];
    shop.name = name;
    return shop;
}

+ (NSArray *)getShopSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDBShop];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kDBShopName ascending:YES]];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    return matches;
}


+ (void)createMockShopInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSArray* currentShop = [DBShop getShopSortedInManagedObjectContext:managedObjectContext];
    for (DBShop* shop in currentShop) {
        [managedObjectContext deleteObject:shop];
    }
    
    NSArray* shopArray = @[];
    
    for (NSString* name in shopArray) {
        [DBShop createWithName:name InManagedObjectContext:managedObjectContext];
    }
}
@end
