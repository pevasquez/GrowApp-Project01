//
//  DBShop.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 8/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBUser.h"

@class DBArtist, DBBodyPart, DBComment, DBInk, DBTattooType, DBUser;

@interface DBShop : DBUser

@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSString * eMail;
@property (nonatomic, retain) NSString * defaultLaguage;
@property (nonatomic, retain) NSSet *hasArtists;
@property (nonatomic, retain) NSSet *hasBodyParts;
@property (nonatomic, retain) NSSet *hasComments;
@property (nonatomic, retain) NSSet *hasInks;
@property (nonatomic, retain) NSSet *hasTattooType;
@property (nonatomic, retain) NSSet *hasUser;
@end

@interface DBShop (CoreDataGeneratedAccessors)

- (void)addHasArtistsObject:(DBArtist *)value;
- (void)removeHasArtistsObject:(DBArtist *)value;
- (void)addHasArtists:(NSSet *)values;
- (void)removeHasArtists:(NSSet *)values;

- (void)addHasBodyPartsObject:(DBBodyPart *)value;
- (void)removeHasBodyPartsObject:(DBBodyPart *)value;
- (void)addHasBodyParts:(NSSet *)values;
- (void)removeHasBodyParts:(NSSet *)values;

- (void)addHasCommentsObject:(DBComment *)value;
- (void)removeHasCommentsObject:(DBComment *)value;
- (void)addHasComments:(NSSet *)values;
- (void)removeHasComments:(NSSet *)values;

- (void)addHasInksObject:(DBInk *)value;
- (void)removeHasInksObject:(DBInk *)value;
- (void)addHasInks:(NSSet *)values;
- (void)removeHasInks:(NSSet *)values;

- (void)addHasTattooTypeObject:(DBTattooType *)value;
- (void)removeHasTattooTypeObject:(DBTattooType *)value;
- (void)addHasTattooType:(NSSet *)values;
- (void)removeHasTattooType:(NSSet *)values;

- (void)addHasUserObject:(DBUser *)value;
- (void)removeHasUserObject:(DBUser *)value;
- (void)addHasUser:(NSSet *)values;
- (void)removeHasUser:(NSSet *)values;

@end
