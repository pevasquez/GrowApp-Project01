//
//  DBBoard.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBUser;

@interface DBBoard : NSManagedObject

@property (nonatomic, retain) id boardCover;
@property (nonatomic, retain) NSString * boardDescription;
@property (nonatomic, retain) NSString * boardID;
@property (nonatomic, retain) NSString * boardTitle;
@property (nonatomic, retain) NSSet *inks;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) DBUser *user;
@end

@interface DBBoard (CoreDataGeneratedAccessors)

- (void)addInksObject:(DBInk *)value;
- (void)removeInksObject:(DBInk *)value;
- (void)addInks:(NSSet *)values;
- (void)removeInks:(NSSet *)values;

@end
