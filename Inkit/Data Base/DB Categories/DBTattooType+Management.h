//
//  DBTattooType+Management.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 6/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBTattooType.h"

@interface DBTattooType (Management)
+ (DBTattooType *)fromJson:(NSDictionary *)tattooTypeDictionary;

// Get Body Parts
+ (NSArray *)getTattooTypeSorted;
+ (NSString *)stringFromArray:(NSArray *)tattooTypesArray;
@end
