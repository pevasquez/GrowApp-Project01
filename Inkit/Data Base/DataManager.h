//
//  DataManager.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 26/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBUser+Management.h"

@interface DataManager : NSObject
+ (DataManager*)sharedInstance;
+ (void)saveContext;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) DBUser* activeUser;

+ (void)loadBodyPartsFromJson:(NSDictionary *)jsonDictionary;
+ (void)loadTattooTypesFromJson:(NSDictionary *)jsonDictionary;

@end
