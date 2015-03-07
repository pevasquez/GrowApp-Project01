//
//  DBInk.h
//  Inkit
//
<<<<<<< HEAD
//  Created by María Verónica  Sonzini on 6/3/15.
=======
//  Created by Cristian Pena on 5/3/15.
>>>>>>> FETCH_HEAD
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

<<<<<<< HEAD
@class DBBoard, DBBodyPart, DBTattooType, DBUser;
=======
@class DBBoard, DBBodyPart, DBUser;
>>>>>>> FETCH_HEAD

@interface DBInk : NSManagedObject

@property (nonatomic, retain) NSString * inkDescription;
@property (nonatomic, retain) NSNumber * inkID;
@property (nonatomic, retain) id inkImage;
@property (nonatomic, retain) DBBoard *inBoard;
<<<<<<< HEAD
@property (nonatomic, retain) NSSet *ofBodyParts;
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) NSSet *ofTattooTypes;
=======
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) NSSet *ofBodyParts;
>>>>>>> FETCH_HEAD
@end

@interface DBInk (CoreDataGeneratedAccessors)

- (void)addOfBodyPartsObject:(DBBodyPart *)value;
- (void)removeOfBodyPartsObject:(DBBodyPart *)value;
- (void)addOfBodyParts:(NSSet *)values;
- (void)removeOfBodyParts:(NSSet *)values;

<<<<<<< HEAD
- (void)addOfTattooTypesObject:(DBTattooType *)value;
- (void)removeOfTattooTypesObject:(DBTattooType *)value;
- (void)addOfTattooTypes:(NSSet *)values;
- (void)removeOfTattooTypes:(NSSet *)values;

=======
>>>>>>> FETCH_HEAD
@end
