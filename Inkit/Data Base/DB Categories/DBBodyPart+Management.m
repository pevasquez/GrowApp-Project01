//
//  DBBodyParts+Management.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBBodyPart+Management.h"

#define kDBBodyPart     @"DBBodyPart"
#define kDBBodyPartName @"name"

@implementation DBBodyPart (Management)

+ (DBBodyPart *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBBodyPart* bodyPart = [NSEntityDescription insertNewObjectForEntityForName:kDBBodyPart inManagedObjectContext:managedObjectContext];
    return bodyPart;
}

+ (DBBodyPart *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBBodyPart* bodyPart = [DBBodyPart createInManagedObjectContext:managedObjectContext];
    bodyPart.name = name;
    return bodyPart;
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


+ (void)createMockBodyPartsInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSArray* currentBodyParts = [DBBodyPart getBodyPartsSortedInManagedObjectContext:managedObjectContext];
    for (DBBodyPart* bodyPart in currentBodyParts) {
        [managedObjectContext deleteObject:bodyPart];
    }
    
    NSArray* bodyPartsArray = @[@"Ankle",
                                @"Arm",
                                @"Back",
                                @"Bicep",
                                @"Chest",
                                @"Ear",
                                @"Face",
                                @"Foot",
                                @"Hand",
                                @"Head",
                                @"Leg",
                                @"Lip",
                                @"Neck",
                                @"Shoulder",
                                @"Stomach",
                                @"Wrist"];
    
    for (NSString* name in bodyPartsArray) {
        [DBBodyPart createWithName:name InManagedObjectContext:managedObjectContext];
    }
}

@end
