//
//  DBBoard.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 3/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBUser;

@interface DBBoard : NSManagedObject

@property (nonatomic, retain) id boardCover;
@property (nonatomic, retain) NSString * boardDescription;
@property (nonatomic, retain) NSString * boardTitle;
@property (nonatomic, retain) NSNumber * boardID;
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) NSSet *inks;
@end

@interface DBBoard (CoreDataGeneratedAccessors)

- (void)addInksObject:(DBInk *)value;
- (void)removeInksObject:(DBInk *)value;
- (void)addInks:(NSSet *)values;
- (void)removeInks:(NSSet *)values;

@end
