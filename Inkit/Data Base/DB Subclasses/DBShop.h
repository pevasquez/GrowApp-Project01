//
//  DBShop.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBUser.h"

@class DBInk, DBUser;

@interface DBShop : DBUser

@property (nonatomic, retain) NSString * defaultLaguage;
@property (nonatomic, retain) NSString * eMail;
@property (nonatomic, retain) NSNumber * shopID;
@property (nonatomic, retain) NSSet *didInks;
@property (nonatomic, retain) NSSet *user;
@end

@interface DBShop (CoreDataGeneratedAccessors)

- (void)addDidInksObject:(DBInk *)value;
- (void)removeDidInksObject:(DBInk *)value;
- (void)addDidInks:(NSSet *)values;
- (void)removeDidInks:(NSSet *)values;

- (void)addUserObject:(DBUser *)value;
- (void)removeUserObject:(DBUser *)value;
- (void)addUser:(NSSet *)values;
- (void)removeUser:(NSSet *)values;

@end
