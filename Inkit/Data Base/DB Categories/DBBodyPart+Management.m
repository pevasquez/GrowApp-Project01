//
//  DBBodyParts+Management.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBBodyPart+Management.h"
#import "DataManager.h"

#define kDBBodyPart     @"DBBodyPart"
#define kDBBodyPartName @"name"

@implementation DBBodyPart (Management)

+ (DBBodyPart *)withID:(NSString *)bodyPartId
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bodyPartId = %@",bodyPartId];
    return (DBBodyPart *)[[DataManager sharedInstance] first:kDBBodyPart predicate:predicate sort:nil limit:1];
}

+ (DBBodyPart *)fromJson:(NSDictionary *)bodyPartData
{
    NSString* bodyPartID = [NSString stringWithFormat:@"%@",bodyPartData[@"id"]] ;
    DBBodyPart* obj = [DBBodyPart withID:bodyPartID];
    DBBodyPart* bodyPart = nil;
    if (!obj) {
        bodyPart = (DBBodyPart *)[[DataManager sharedInstance] insert:kDBBodyPart];
        bodyPart.bodyPartId = bodyPartID;
    } else {
        bodyPart = obj;
    }
    [bodyPart updateWithJson:bodyPartData];
    [DataManager saveContext];
    return bodyPart;
}

- (void)updateWithJson:(NSDictionary *)bodyPartDictionary
{
    if ([bodyPartDictionary objectForKey:@"name"]) {
        self.name = [bodyPartDictionary objectForKey:@"name"];
    }
}

+ (NSArray *)getBodyPartsSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDBBodyPart];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:kDBBodyPartName ascending:YES]];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray* bodyParts = [[NSMutableArray alloc] init];
    
    if ([matches count]&&!error) {
        for (DBBodyPart* bodyPart in matches) {
            [bodyParts addObject:bodyPart];
        }
        return bodyParts;
    } else {
        return nil;
    }
}

@end
