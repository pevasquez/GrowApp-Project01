//
//  DBArtist.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 30/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBoard, DBBodyPart, DBInk, DBShop, DBTattooType;

@interface DBArtist : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *inShop;
@property (nonatomic, retain) NSSet *hasInks;
@property (nonatomic, retain) NSSet *hasTattooType;
@property (nonatomic, retain) NSSet *hasBoards;
@property (nonatomic, retain) DBBodyPart *hasBodyParts;
@end

@interface DBArtist (CoreDataGeneratedAccessors)

- (void)addInShopObject:(DBShop *)value;
- (void)removeInShopObject:(DBShop *)value;
- (void)addInShop:(NSSet *)values;
- (void)removeInShop:(NSSet *)values;

- (void)addHasInksObject:(DBInk *)value;
- (void)removeHasInksObject:(DBInk *)value;
- (void)addHasInks:(NSSet *)values;
- (void)removeHasInks:(NSSet *)values;

- (void)addHasTattooTypeObject:(DBTattooType *)value;
- (void)removeHasTattooTypeObject:(DBTattooType *)value;
- (void)addHasTattooType:(NSSet *)values;
- (void)removeHasTattooType:(NSSet *)values;

- (void)addHasBoardsObject:(DBBoard *)value;
- (void)removeHasBoardsObject:(DBBoard *)value;
- (void)addHasBoards:(NSSet *)values;
- (void)removeHasBoards:(NSSet *)values;

@end
