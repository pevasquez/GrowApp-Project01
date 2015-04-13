//
//  DBBodyPart.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBShop, DBUser;

@interface DBBodyPart : NSManagedObject

@property (nonatomic, retain) NSNumber * bodyPartId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *users;
@property (nonatomic, retain) NSSet *inks;
@end

@interface DBBodyPart (CoreDataGeneratedAccessors)

- (void)addUsersObject:(DBUser *)value;
- (void)removeUsersObject:(DBUser *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

- (void)addInksObject:(DBInk *)value;
- (void)removeInksObject:(DBInk *)value;
- (void)addInks:(NSSet *)values;
- (void)removeInks:(NSSet *)values;

@end
