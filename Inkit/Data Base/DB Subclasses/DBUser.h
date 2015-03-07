//
//  DBUser.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
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
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * updatedTime;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) id userImage;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSSet *boards;
@property (nonatomic, retain) NSSet *inks;
@property (nonatomic, retain) NSSet *comments;
@end

@interface DBUser (CoreDataGeneratedAccessors)

- (void)addBoardsObject:(DBBoard *)value;
- (void)removeBoardsObject:(DBBoard *)value;
- (void)addBoards:(NSSet *)values;
- (void)removeBoards:(NSSet *)values;

- (void)addInksObject:(DBInk *)value;
- (void)removeInksObject:(DBInk *)value;
- (void)addInks:(NSSet *)values;
- (void)removeInks:(NSSet *)values;

- (void)addCommentsObject:(DBComment *)value;
- (void)removeCommentsObject:(DBComment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
