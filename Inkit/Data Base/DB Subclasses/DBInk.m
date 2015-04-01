//
//  DBInk.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 1/4/15.
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

@dynamic inkDescription;
@dynamic inkID;
@dynamic likesCount;
@dynamic reInksCount;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic extraData;
@dynamic hasComments;
@dynamic inBoard;
@dynamic ofArtist;
@dynamic ofBodyParts;
@dynamic ofShop;
@dynamic ofTattooTypes;
@dynamic user;
@dynamic image;

@end
