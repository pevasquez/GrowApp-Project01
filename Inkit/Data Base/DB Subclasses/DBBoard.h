//
//  DBBoard.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 1/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBArtist, DBInk, DBUser;

@interface DBBoard : NSManagedObject

@property (nonatomic, retain) id boardCover;
@property (nonatomic, retain) NSString * boardDescription;
@property (nonatomic, retain) NSNumber * boardID;
@property (nonatomic, retain) NSString * boardTitle;
@property (nonatomic, retain) DBArtist *inArtist;
@property (nonatomic, retain) NSSet *inks;
@property (nonatomic, retain) DBUser *ofUser;
@property (nonatomic, retain) DBUser *user;
@end

@interface DBBoard (CoreDataGeneratedAccessors)

- (void)addInksObject:(DBInk *)value;
- (void)removeInksObject:(DBInk *)value;
- (void)addInks:(NSSet *)values;
- (void)removeInks:(NSSet *)values;

@end
