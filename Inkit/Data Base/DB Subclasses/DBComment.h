//
//  DBComment.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBUser;

@interface DBComment : NSManagedObject

@property (nonatomic, retain) NSDate * commentDate;
@property (nonatomic, retain) NSString * commentID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) DBInk *ink;
@property (nonatomic, retain) DBUser *user;

@end
