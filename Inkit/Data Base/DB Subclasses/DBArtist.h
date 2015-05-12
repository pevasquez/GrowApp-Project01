//
//  DBArtist.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBUser.h"

@class DBInk, DBUser;

@interface DBArtist : DBUser

@property (nonatomic, retain) NSString * artistId;
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) NSSet *didInks;
@end

@interface DBArtist (CoreDataGeneratedAccessors)

- (void)addDidInksObject:(DBInk *)value;
- (void)removeDidInksObject:(DBInk *)value;
- (void)addDidInks:(NSSet *)values;
- (void)removeDidInks:(NSSet *)values;

@end
