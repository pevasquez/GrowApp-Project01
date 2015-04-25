//
//  DBTattooType+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 6/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBTattooType+Management.h"
#import "DataManager.h"
#import "InkitConstants.h"

@implementation DBTattooType (Management)

#define KDBTattooType @"DBTattooType"
#define kDBTattooTypeName @"name"

+ (DBTattooType *)withID:(NSString *)tattooTypeId
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tattooTypeId = %@",tattooTypeId];
    return (DBTattooType *)[[DataManager sharedInstance] first:KDBTattooType predicate:predicate sort:nil limit:1];
}

+ (DBTattooType *)fromJson:(NSDictionary *)tattooTypeData
{
    NSString* tattooTypeID = [NSString stringWithFormat:@"%@",tattooTypeData[@"id"]] ;
    DBTattooType* obj = [DBTattooType withID:tattooTypeID];
    DBTattooType* tattooType = nil;
    if (!obj) {
        tattooType = (DBTattooType *)[[DataManager sharedInstance] insert:KDBTattooType];
        tattooType.tattooTypeId = tattooTypeID;
    } else {
        tattooType = obj;
    }
    [tattooType updateWithJson:tattooTypeData];
    [DataManager saveContext];
    return tattooType;
}

- (void)updateWithJson:(NSDictionary *)tattooTypeDictionary
{
    if ([tattooTypeDictionary objectForKey:@"name"]) {
        self.name = [tattooTypeDictionary objectForKey:@"name"];
    }
}

+ (NSArray *)getTattooTypeSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:KDBTattooType];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kDBTattooTypeName ascending:YES]];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray* tattooTypes = [[NSMutableArray alloc] init];
    
    if ([matches count]&&!error) {
        for (DBTattooType* tattooType in matches) {
            [tattooTypes addObject:tattooType];
        }
        return tattooTypes;
    } else {
        return nil;
    }
}

@end
