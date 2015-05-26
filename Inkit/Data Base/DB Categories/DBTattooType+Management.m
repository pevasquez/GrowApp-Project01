//
//  DBTattooType+Management.m
//  Inkit
//
//  Created by Cristian Pena on 6/3/15.
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

- (void)updateWithJson:(NSDictionary *)tattooTypeDictionary {
    
    if ([tattooTypeDictionary objectForKey:@"name"]) {
        self.name = [tattooTypeDictionary objectForKey:@"name"];
    }
}

+ (NSArray *)getTattooTypeSorted {
    
    return [[DataManager sharedInstance] fetch:KDBTattooType predicate:nil sort:@[[NSSortDescriptor sortDescriptorWithKey:kDBTattooTypeName ascending:YES]] limit:0];
}

+ (NSString *)stringFromArray:(NSArray *)tattooTypesArray {
    NSString* tattooTypesString = [[NSMutableString alloc] init];
    
    for (DBTattooType* tattooType in tattooTypesArray) {
        tattooTypesString = [tattooTypesString stringByAppendingString:[NSString stringWithFormat:@"%@",tattooType.name]];
        if (!(tattooType == tattooTypesArray.lastObject)) {
            tattooTypesString = [tattooTypesString stringByAppendingString:@", "];
        }
    }
    return tattooTypesString;
}
@end
