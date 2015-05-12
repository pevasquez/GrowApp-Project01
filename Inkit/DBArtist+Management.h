//
//  DBArtist+Management.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBArtist.h"

@interface DBArtist (Management)
+ (DBArtist *)createWithName:(NSString *)name InManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

// Get Artist
+ (NSArray *)getArtistSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBArtist *)fromJson: (NSDictionary *)jsonDictionary;
@end
