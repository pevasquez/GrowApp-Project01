//
//  DBTattooType+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 6/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBTattooType+Management.h"

@implementation DBTattooType (Management)


#import "DBTattooType+Management.h"

#define KDBTattooType @"DBTattooType"
#define kDBTattooTypeName @"name"

+ (DBTattooType *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBTattooType* tattooType = [NSEntityDescription insertNewObjectForEntityForName:KDBTattooType
                                                             inManagedObjectContext:managedObjectContext];
    return tattooType;
}

+ (DBTattooType *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBTattooType* tattooType = [DBTattooType createInManagedObjectContext:managedObjectContext];
    tattooType.name = name;
    return tattooType;
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


+ (void)createMockTattooTypesInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSArray* currentTattoTypes = [DBTattooType getTattooTypeSortedInManagedObjectContext:managedObjectContext];
    for (DBTattooType* tattooTypes in currentTattoTypes) {
        [managedObjectContext deleteObject:tattooTypes];
    }
    
    NSArray* tattooTypesArray = @[@"Abstract",
                                
                                @"Ambigram",
                                
                                @"Anchor",
                                
                                @"Angel",
                                
                                @"Animal",
                                
                                @"Armband",
                                
                                @"Astrology",
                                
                                @"Baby",
                                
                                @"Barcode",
                                
                                @"Bio-mechanical",
                                
                                @"Bird",
                                
                                @"Black and Grey",
                                
                                @"Buddha",
                                
                                @"Butterfly",
                                
                                @"Cartoons",
                                
                                @"Cat",
                                
                                @"Celebrity",
                                
                                @"Celestial",
                                
                                @"Celtic",
                                
                                @"Chinese",
                                
                                @"Christian",
                                
                                @"Comic",
                                
                                @"Couples",
                                
                                @"Cover up",
                                
                                @"Cross",
                                
                                @"Dagger",
                                
                                @"Death",
                                
                                @"Demon",
                                
                                @"Devil",
                                
                                @"Dog",
                                
                                @"Dragon",
                                
                                @"Dragonfly",
                                
                                @"Dream Catcher",
                                
                                @"Eagle",
                                
                                @"Fairy",
                                
                                @"Fantasy",
                                
                                @"Feather",
                                
                                @"Fire",
                                
                                @"Flower",
                                
                                @"Heart",
                                
                                @"Indian",
                                
                                @"Japanese",
                                
                                @"Jesus",
                                
                                @"Lettering",
                                
                                @"Macabre",
                                
                                @"Maori",
                                
                                @"Mashup",
                                
                                @"Memorial",
                                
                                @"Military",
                                
                                @"Moon",
                                
                                @"Music",
                                
                                @"Name",
                                
                                @"Other",
                                
                                @"Owl",
                                
                                @"Patriotic",
                                
                                @"Peace",
                                
                                @"Peacock",
                                
                                @"People",
                                
                                @"Phoenix",
                                
                                @"Piercing",
                                
                                @"Pinup",
                                
                                @"Portraits",
                                
                                @"Praying Hands",
                                
                                @"Quote",
                                
                                @"Realistic",
                                
                                @"Religious",
                                
                                @"Ring",
                                
                                @"Rose",
                                
                                @"Samoan",
                                
                                @"Samurai",
                                
                                @"Scorpion",
                                
                                @"Sexy",
                                
                                @"Skull",
                                
                                @"Sparrow",
                                
                                @"Spider",
                                
                                @"Sports",
                                
                                @"Star",
                                
                                @"Sun",
                                
                                @"Symbols",
                                
                                @"Tiger",
                                
                                @"Traditional",
                                
                                @"Trash Polka",
                                
                                @"Tree",
                                
                                @"Tribal",
                                
                                @"Wings",
                                
                                @"Wolf",];
    
    for (NSString* name in tattooTypesArray) {
        [DBTattooType createWithName:name InManagedObjectContext:managedObjectContext];
    }
}

@end
