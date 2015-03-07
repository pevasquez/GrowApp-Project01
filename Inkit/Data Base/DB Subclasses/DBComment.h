//
//  DBComment.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBUser;

@interface DBComment : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) DBUser *ofUser;
@property (nonatomic, retain) DBInk *inInk;

@end
