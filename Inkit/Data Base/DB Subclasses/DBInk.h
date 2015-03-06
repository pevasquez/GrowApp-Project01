//
//  DBInk.h
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBoard, DBBodyPart, DBUser;

@interface DBInk : NSManagedObject

@property (nonatomic, retain) NSString * inkDescription;
@property (nonatomic, retain) NSNumber * inkID;
@property (nonatomic, retain) id inkImage;
@property (nonatomic, retain) DBBoard *inBoard;
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) NSSet *ofBodyParts;
@end

@interface DBInk (CoreDataGeneratedAccessors)

- (void)addOfBodyPartsObject:(DBBodyPart *)value;
- (void)removeOfBodyPartsObject:(DBBodyPart *)value;
- (void)addOfBodyParts:(NSSet *)values;
- (void)removeOfBodyParts:(NSSet *)values;

@end
