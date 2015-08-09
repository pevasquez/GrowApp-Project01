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
+ (DBBodyPart *)newBodyPart {
    DBBodyPart* bodyPart = (DBBodyPart *)[[DataManager sharedInstance] insert:kDBBodyPart];
    return bodyPart;
}

+ (DBBodyPart *)withID:(NSString *)bodyPartId {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"bodyPartId = %@",bodyPartId];
    return (DBBodyPart *)[[DataManager sharedInstance] first:kDBBodyPart predicate:predicate sort:nil limit:1];
}

+ (DBBodyPart *)fromJson:(NSDictionary *)bodyPartData {
    NSString* bodyPartID = [NSString stringWithFormat:@"%@",bodyPartData[@"id"]] ;
    DBBodyPart* obj = [DBBodyPart withID:bodyPartID];
    DBBodyPart* bodyPart = nil;
    if (!obj) {
        bodyPart = [DBBodyPart newBodyPart];
        bodyPart.bodyPartId = bodyPartID;
    } else {
        bodyPart = obj;
    }
    [bodyPart updateWithJson:bodyPartData];
    return bodyPart;
}

- (void)updateWithJson:(NSDictionary *)bodyPartDictionary {
    if ([bodyPartDictionary objectForKey:@"name"]) {
        self.name = [bodyPartDictionary objectForKey:@"name"];
    }
}

+ (NSArray *)getBodyPartsSorted {
    
    return [[DataManager sharedInstance] fetch:kDBBodyPart predicate:nil sort:@[[NSSortDescriptor sortDescriptorWithKey:kDBBodyPartName ascending:YES]] limit:0];
}

+ (NSString *)stringFromArray:(NSArray *)bodyPartsArray {
    NSString* bodyPartsString = [[NSMutableString alloc] init];
    
    for (DBBodyPart* bodyPart in bodyPartsArray) {
        bodyPartsString = [bodyPartsString stringByAppendingString:[NSString stringWithFormat:@"%@",bodyPart.name]];
        if (!(bodyPart == bodyPartsArray.lastObject)) {
            bodyPartsString = [bodyPartsString stringByAppendingString:@", "];
        }
    }
    return bodyPartsString;
}


@end
