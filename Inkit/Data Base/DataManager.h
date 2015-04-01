//
//  DataManager.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 26/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject
+ (DataManager*)sharedInstance;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@end
