//
//  DBInk.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBoard, DBBodyPart, DBComment, DBTattooType, DBUser;

@interface DBInk : NSManagedObject

@property (nonatomic, retain) NSString * inkDescription;
@property (nonatomic, retain) NSNumber * inkID;
@property (nonatomic, retain) id inkImage;
@property (nonatomic, retain) DBBoard *inBoard;
@property (nonatomic, retain) NSSet *ofBodyParts;
@property (nonatomic, retain) NSSet *ofTattooTypes;
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) NSSet *hasComments;
@end

@interface DBInk (CoreDataGeneratedAccessors)

- (void)addOfBodyPartsObject:(DBBodyPart *)value;
- (void)removeOfBodyPartsObject:(DBBodyPart *)value;
- (void)addOfBodyParts:(NSSet *)values;
- (void)removeOfBodyParts:(NSSet *)values;

- (void)addOfTattooTypesObject:(DBTattooType *)value;
- (void)removeOfTattooTypesObject:(DBTattooType *)value;
- (void)addOfTattooTypes:(NSSet *)values;
- (void)removeOfTattooTypes:(NSSet *)values;

- (void)addHasCommentsObject:(DBComment *)value;
- (void)removeHasCommentsObject:(DBComment *)value;
- (void)addHasComments:(NSSet *)values;
- (void)removeHasComments:(NSSet *)values;

@end
