//
//  DBBodyPart.h
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk;

@interface DBBodyPart : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *inInks;
@end

@interface DBBodyPart (CoreDataGeneratedAccessors)

- (void)addInInksObject:(DBInk *)value;
- (void)removeInInksObject:(DBInk *)value;
- (void)addInInks:(NSSet *)values;
- (void)removeInInks:(NSSet *)values;

@end
