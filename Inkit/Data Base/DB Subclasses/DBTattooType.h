//
//  DBTattooType.h
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBArtist, DBInk, DBShop;

@interface DBTattooType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * tattooTypeId;
@property (nonatomic, retain) DBArtist *inArtist;
@property (nonatomic, retain) DBInk *inInks;
@property (nonatomic, retain) DBShop *inShop;

@end
