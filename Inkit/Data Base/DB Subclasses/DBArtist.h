//
//  DBArtist.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 8/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBUser.h"

@class DBBodyPart, DBInk, DBShop, DBTattooType;

@interface DBArtist : DBUser

@property (nonatomic, retain) NSNumber * artistId;
@property (nonatomic, retain) DBBodyPart *hasBodyParts;
@property (nonatomic, retain) NSSet *hasInks;
@property (nonatomic, retain) NSSet *hasTattooType;
@property (nonatomic, retain) NSSet *inShop;
@end

@interface DBArtist (CoreDataGeneratedAccessors)

- (void)addHasInksObject:(DBInk *)value;
- (void)removeHasInksObject:(DBInk *)value;
- (void)addHasInks:(NSSet *)values;
- (void)removeHasInks:(NSSet *)values;

- (void)addHasTattooTypeObject:(DBTattooType *)value;
- (void)removeHasTattooTypeObject:(DBTattooType *)value;
- (void)addHasTattooType:(NSSet *)values;
- (void)removeHasTattooType:(NSSet *)values;

- (void)addInShopObject:(DBShop *)value;
- (void)removeInShopObject:(DBShop *)value;
- (void)addInShop:(NSSet *)values;
- (void)removeInShop:(NSSet *)values;

@end
