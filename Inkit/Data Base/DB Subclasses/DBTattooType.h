//
//  DBTattooType.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 6/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk;

@interface DBTattooType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DBInk *inInks;

@end
