//
//  DBTattooType.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBShop, DBUser;

@interface DBTattooType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * tattooTypeId;
@property (nonatomic, retain) DBInk *inks;
@property (nonatomic, retain) DBUser *user;

@end
