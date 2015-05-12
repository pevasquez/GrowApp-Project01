//
//  DBShop+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBShop+Management.h"
#import "DBUser+Management.h"
#import "DataManager.h"
#import "InkitConstants.h"

@implementation DBShop (Management)


#define kDBShopName @"name"
+ (DBShop *)newShop
{
    DBShop* shop = (DBShop *)[[DataManager sharedInstance] insert:kDBShop];
    shop.name = @"";
    return shop;
}

+ (DBShop *)fromJson:(NSDictionary *)jsonDictionary
{
    DBShop* shop = [DBShop newShop];
    [shop updateWithJson:jsonDictionary];
    return shop;
}

- (void)updateWithJson:(NSDictionary *)jsonDictionary
{
    [super updateWithJson:jsonDictionary];
}


+ (NSArray *)getShopSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDBShop];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kDBShopName ascending:YES]];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    return matches;
}

@end
