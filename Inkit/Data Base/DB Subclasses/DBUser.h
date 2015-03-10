//
//  DBUser.h
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBBoard, DBComment, DBInk;

@interface DBUser : NSManagedObject

@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSNumber * token;
@property (nonatomic, retain) NSString * updatedTime;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) id userImage;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSOrderedSet *boards;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *inks;
@property (nonatomic, retain) NSOrderedSet *hasBoards;
@end

@interface DBUser (CoreDataGeneratedAccessors)

- (void)insertObject:(DBBoard *)value inBoardsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBoardsAtIndex:(NSUInteger)idx;
- (void)insertBoards:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBoardsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBoardsAtIndex:(NSUInteger)idx withObject:(DBBoard *)value;
- (void)replaceBoardsAtIndexes:(NSIndexSet *)indexes withBoards:(NSArray *)values;
- (void)addBoardsObject:(DBBoard *)value;
- (void)removeBoardsObject:(DBBoard *)value;
- (void)addBoards:(NSOrderedSet *)values;
- (void)removeBoards:(NSOrderedSet *)values;
- (void)addCommentsObject:(DBComment *)value;
- (void)removeCommentsObject:(DBComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addInksObject:(DBInk *)value;
- (void)removeInksObject:(DBInk *)value;
- (void)addInks:(NSSet *)values;
- (void)removeInks:(NSSet *)values;

- (void)insertObject:(DBBoard *)value inHasBoardsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromHasBoardsAtIndex:(NSUInteger)idx;
- (void)insertHasBoards:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeHasBoardsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInHasBoardsAtIndex:(NSUInteger)idx withObject:(DBBoard *)value;
- (void)replaceHasBoardsAtIndexes:(NSIndexSet *)indexes withHasBoards:(NSArray *)values;
- (void)addHasBoardsObject:(DBBoard *)value;
- (void)removeHasBoardsObject:(DBBoard *)value;
- (void)addHasBoards:(NSOrderedSet *)values;
- (void)removeHasBoards:(NSOrderedSet *)values;
@end
