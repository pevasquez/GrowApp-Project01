//
//  DBArtist+Management.h
//  Inkit
//
//  Created by Cristian Pena on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBArtist.h"

@interface DBArtist (Management)

// Get Artist
//+ (NSArray *)getArtistSortedInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (DBArtist *)fromJson: (NSDictionary *)jsonDictionary;
@end
