//
//  IKInk.h
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IKImage.h"

@class IKBoard, IKImage;

@interface IKInk : NSObject

@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSNumber * loggedUserLikes;
@property (nonatomic, strong) NSNumber * loggedUserReInked;
@property (nonatomic, strong) NSNumber * extraData;
@property (nonatomic, strong) NSString * inkDescription;
@property (nonatomic, strong) NSString * inkID;
@property (nonatomic, strong) NSNumber * commentsCount;
@property (nonatomic, strong) NSNumber * likesCount;
@property (nonatomic, strong) NSNumber * reInksCount;
@property (nonatomic, strong) NSDate * updatedAt;
//@property (nonatomic, strong) IKArtist *artist;
@property (nonatomic, strong) IKBoard *board;
@property (nonatomic, strong) NSSet *bodyParts;
@property (nonatomic, strong) NSSet *comments;
@property (nonatomic, strong) IKImage *fullScreenImage;
@property (nonatomic, strong) IKImage *image;
@property (nonatomic, strong) DBUser *likedByUser;
@property (nonatomic, strong) DBShop *shop;
@property (nonatomic, strong) NSSet *tattooTypes;
@property (nonatomic, strong) IKImage *thumbnailImage;
@property (nonatomic, strong) DBUser *user;
@property (nonatomic, strong) DBUser *userDashboard;

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
