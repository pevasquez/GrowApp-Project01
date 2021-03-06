//
//  DBBodyParts+Management.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBBodyPart.h"

@interface DBBodyPart (Management)
+ (DBBodyPart *)fromJson:(NSDictionary *)bodyPartDictionary;
+ (NSString *)stringFromArray:(NSArray *)bodyPartsArray;

// Get Body Parts
+ (NSArray *)getBodyPartsSorted;
@end
