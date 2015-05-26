//
//  DataManager.h
//  Inkit
//
//  Created by Cristian Pena on 26/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBUser+Management.h"

@interface DataManager : NSObject
+ (DataManager*)sharedInstance;
+ (void)saveContext;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) DBUser* activeUser;

+ (void)loadBodyPartsFromJson:(NSDictionary *)jsonDictionary;
+ (void)loadTattooTypesFromJson:(NSDictionary *)jsonDictionary;

- (void)saveContext;
- (NSManagedObject *)insert:(NSString *)type;
- (void)insertAsync:(NSString *)type completion:(void (^)(NSManagedObject *))completion;
- (void)deleteObject:(NSManagedObject *)object;
- (void)deleteObjectAsync:(NSManagedObject *)object completion:(void (^)())completion;
- (NSArray *)fetch:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit;
- (void)fetchAsync:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit completion:(void (^)(NSArray *))completion;
- (NSManagedObject *)first:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit;
- (void)firstAsync:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit completion:(void (^)(NSArray *))completion;
- (NSUInteger) count:(NSString *)type predicate:(NSPredicate *)predicate;
- (void)countAsync:(NSString *)type predicate:(NSPredicate *)predicate completion:(void (^)(NSUInteger))completion;

@end
