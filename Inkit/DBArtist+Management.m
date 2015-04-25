//
//  DBArtist+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBArtist+Management.h"
#import "DataManager.h"
#import "DBUser+Management.h"

@implementation DBArtist (Management)

#define KDBArtist @"DBArtist"
#define KDBArtistName @"name"

+ (DBArtist *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBArtist* artist = [NSEntityDescription insertNewObjectForEntityForName:KDBArtist
                                                             inManagedObjectContext:managedObjectContext];
    return artist;
}

+ (DBArtist *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBArtist* artist = [DBArtist createInManagedObjectContext:managedObjectContext];
    artist.name = name;
    return artist;
}

+ (DBArtist *)withID:(NSString *)artistId
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"artistId = %@",artistId];
    return (DBArtist *)[[DataManager sharedInstance] first:KDBArtist predicate:predicate sort:nil limit:1];
}

+ (DBArtist *)fromJson:(NSDictionary *)artistData
{
    NSString* artistID = artistData[@"id"];
    DBArtist* obj = [DBArtist withID:artistID];
    DBArtist* artist = nil;
    if (!obj) {
        artist = (DBArtist *)[[DataManager sharedInstance] insert:KDBArtist];
    } else {
        artist = obj;
    }
    [artist updateWithJson:artistData];
    [DataManager saveContext];
    return artist;
}

- (void)updateWithJson:(NSDictionary *)jsonDictionary
{
    [super updateWithJson:jsonDictionary];
}


+ (NSArray *)getArtistSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:KDBArtist];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:KDBArtistName ascending:YES]];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    return matches;
}

@end
