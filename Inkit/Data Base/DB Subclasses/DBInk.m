//
//  DBInk.m
//  Inkit
//
//  Created by Cristian Pena on 5/27/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBInk.h"
#import "DBArtist.h"
#import "DBBoard.h"
#import "DBBodyPart.h"
#import "DBComment.h"
#import "DBImage.h"
#import "DBShop.h"
#import "DBTattooType.h"
#import "DBUser.h"


@implementation DBInk

@dynamic createdAt;
@dynamic extraData;
@dynamic inkDescription;
@dynamic inkID;
@dynamic commentsCount;
@dynamic likesCount;
@dynamic reInksCount;
@dynamic updatedAt;
@dynamic artist;
@dynamic board;
@dynamic bodyParts;
@dynamic comments;
@dynamic fullScreenImage;
@dynamic image;
@dynamic likedByUser;
@dynamic shop;
@dynamic tattooTypes;
@dynamic thumbnailImage;
@dynamic user;
@dynamic userDashboard;
@dynamic loggedUserLikes;
@dynamic loggedUserReInked;

@end
