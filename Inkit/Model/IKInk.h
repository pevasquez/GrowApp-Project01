//
//  IKInk.h
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IKBoard;

@interface IKInk : NSObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * loggedUserLikes;
@property (nonatomic, retain) NSNumber * loggedUserReInked;
@property (nonatomic, retain) NSNumber * extraData;
@property (nonatomic, retain) NSString * inkDescription;
@property (nonatomic, retain) NSString * inkID;
@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSNumber * reInksCount;
@property (nonatomic, retain) NSDate * updatedAt;
//@property (nonatomic, retain) IKArtist *artist;
@property (nonatomic, retain) IKBoard *board;
@property (nonatomic, retain) NSSet *bodyParts;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) DBImage *fullScreenImage;
@property (nonatomic, retain) DBImage *image;
@property (nonatomic, retain) DBUser *likedByUser;
@property (nonatomic, retain) DBShop *shop;
@property (nonatomic, retain) NSSet *tattooTypes;
@property (nonatomic, retain) DBImage *thumbnailImage;
@property (nonatomic, retain) DBUser *user;
@property (nonatomic, retain) DBUser *userDashboard;

+ (IKInk *)fromJson:(NSDictionary *)inkData;
- (void)updateWithJson:(NSDictionary *)inkData;
+ (IKInk *)inkWithInk:(IKInk *)ink;
+ (void)deleteInk:(IKInk *)ink completion:(ServiceResponse)completion;

- (UIImage *)getInkImage;
- (CGFloat)getImageAspectRatio;

- (NSString*)getBodyPartsAsString;
- (NSString *)getTattooTypesAsString;
- (NSString *)getArtistsAsString;

- (NSArray *)toArray;
- (NSDictionary *)toDictionary;
+ (NSDictionary *)emptyDictionary;

// Comment Actions
- (NSArray *)getCommentsSorted;
- (void)updateCommentsWithJson:(NSArray *)commentsArray;

@end
