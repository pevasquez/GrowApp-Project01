//
//  DBUser.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBArtist, DBBoard, DBBodyPart, DBComment, DBImage, DBInk, DBShop, DBTattooType;

@interface DBUser : NSManagedObject

@property (nonatomic, retain) NSString * artistShopData;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSNumber * boardsCount;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * defaultLanguage;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebookID;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * inksLikedCount;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSData * profileURL;
@property (nonatomic, retain) NSString * socialNetworks;
@property (nonatomic, retain) NSString * styles;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSNumber * token;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * updatedTime;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSData * userImage;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSOrderedSet *boards;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *inks;
@property (nonatomic, retain) DBImage *profilePic;
@property (nonatomic, retain) DBImage *profilePicThumbnail;
@property (nonatomic, retain) NSSet *shops;
@property (nonatomic, retain) NSSet *artists;
@property (nonatomic, retain) NSSet *tattooTypes;
@property (nonatomic, retain) NSSet *bodyParts;
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

- (void)addShopsObject:(DBShop *)value;
- (void)removeShopsObject:(DBShop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;

- (void)addArtistsObject:(DBArtist *)value;
- (void)removeArtistsObject:(DBArtist *)value;
- (void)addArtists:(NSSet *)values;
- (void)removeArtists:(NSSet *)values;

- (void)addTattooTypesObject:(DBTattooType *)value;
- (void)removeTattooTypesObject:(DBTattooType *)value;
- (void)addTattooTypes:(NSSet *)values;
- (void)removeTattooTypes:(NSSet *)values;

- (void)addBodyPartsObject:(DBBodyPart *)value;
- (void)removeBodyPartsObject:(DBBodyPart *)value;
- (void)addBodyParts:(NSSet *)values;
- (void)removeBodyParts:(NSSet *)values;

@end
