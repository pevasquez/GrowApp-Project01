//
//  DBBodyPart.h
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBArtist, DBInk, DBShop;

@interface DBBodyPart : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * bodyPartId;
@property (nonatomic, retain) DBArtist *inArtist;
@property (nonatomic, retain) NSSet *inInks;
@property (nonatomic, retain) NSSet *inShop;
@end

@interface DBBodyPart (CoreDataGeneratedAccessors)

- (void)addInInksObject:(DBInk *)value;
- (void)removeInInksObject:(DBInk *)value;
- (void)addInInks:(NSSet *)values;
- (void)removeInInks:(NSSet *)values;

- (void)addInShopObject:(DBShop *)value;
- (void)removeInShopObject:(DBShop *)value;
- (void)addInShop:(NSSet *)values;
- (void)removeInShop:(NSSet *)values;

@end
