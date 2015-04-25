//
//  DBInk.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBArtist, DBBoard, DBBodyPart, DBComment, DBImage, DBShop, DBTattooType, DBUser;

@interface DBInk : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * extraData;
@property (nonatomic, retain) NSString * inkDescription;
@property (nonatomic, retain) NSNumber * inkID;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSNumber * reInksCount;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) DBImage *image;
@property (nonatomic, retain) DBBoard *board;
@property (nonatomic, retain) DBArtist *artist;
@property (nonatomic, retain) NSSet *bodyParts;
@property (nonatomic, retain) DBShop *shop;
@property (nonatomic, retain) NSSet *tattooTypes;
@property (nonatomic, retain) DBUser *user;
@end

@interface DBInk (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(DBComment *)value;
- (void)removeCommentsObject:(DBComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addBodyPartsObject:(DBBodyPart *)value;
- (void)removeBodyPartsObject:(DBBodyPart *)value;
- (void)addBodyParts:(NSSet *)values;
- (void)removeBodyParts:(NSSet *)values;

- (void)addTattooTypesObject:(DBTattooType *)value;
- (void)removeTattooTypesObject:(DBTattooType *)value;
- (void)addTattooTypes:(NSSet *)values;
- (void)removeTattooTypes:(NSSet *)values;

@end