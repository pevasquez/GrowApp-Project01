//
//  DataManager.m
//  Inkit
//
//  Created by Cristian Pena on 26/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DataManager.h"
#import "DBUser+Management.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "AppDelegate.h"

#define kActiveUser         @"kActiveUser"

@interface DataManager()
@property (strong, nonatomic) NSNumber* tattooStylesLastVersion;
@property (strong, nonatomic) NSNumber* tattooTypesLastVersion;
@property (strong, nonatomic) NSNumber* bodyPartsLastVersion;
@end

@implementation DataManager
+ (id)sharedInstance
{
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
    }
    return self;
}

+ (void)saveContext
{
    // Save context
    NSError* error = nil;
    [[DataManager sharedInstance].managedObjectContext save:&error];
}

+ (void)loadBodyPartsFromJson:(NSDictionary *)jsonDictionary
{
    [[DataManager sharedInstance] loadBodyPartsFromJson:jsonDictionary];
}

- (void)loadBodyPartsFromJson:(NSDictionary *)jsonDictionary
{
    if ([jsonDictionary objectForKey:@"meta"]) {
        if ([jsonDictionary[@"meta"] objectForKey:@"last_version"]) {
           // NSNumber* lastVersion = [NSNumber numberWithLong:[jsonDictionary[@"last_version"] longValue]];
            //if (lastVersion>=self.bodyPartsLastVersion) {
                // remove body parts
                for (NSDictionary* bodyPartDictionary in jsonDictionary[@"data"]) {
                    [DBBodyPart fromJson:bodyPartDictionary];
                }
            //}
        }
    }
}

+ (void)loadTattooTypesFromJson:(NSDictionary *)jsonDictionary
{
    [[DataManager sharedInstance] loadTattooTypesFromJson:jsonDictionary];
}

- (void)loadTattooTypesFromJson:(NSDictionary *)jsonDictionary
{
    if ([jsonDictionary objectForKey:@"meta"]) {
        if ([jsonDictionary[@"meta"] objectForKey:@"last_version"]) {
//            NSNumber* lastVersion = [NSNumber numberWithInteger:[(NSString *)jsonDictionary[@"last_version"] integerValue]] ;
//            if (lastVersion>=self.bodyPartsLastVersion) {
                // remove tattoo types
                for (NSDictionary* tattooTypeDictionary in jsonDictionary[@"data"]) {
                    [DBTattooType fromJson:tattooTypeDictionary];
                }
//            }
        }
    }
}

#pragma mark - Active User Management

- (void)obtainCurrentUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* userData = [userDefaults objectForKey:kActiveUser];
    if (userData) {
        NSURL* activeUserIDURL = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if (activeUserIDURL) {
            NSPersistentStoreCoordinator *persistentStoreCoordinator = self.persistentStoreCoordinator;
            NSManagedObjectContext* managedObjectContext = self.managedObjectContext;
            NSManagedObjectID *objectID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:activeUserIDURL];
            if (!objectID) {
                return;
            }
            NSManagedObject* objectForID = [managedObjectContext objectWithID:objectID];
            if (![objectForID isFault]) {
                DBUser* user = (DBUser *)[managedObjectContext objectWithID:objectID];
                self.activeUser = user;
            }
            
            NSFetchRequest* request = [[NSFetchRequest alloc] init];
            [request setEntity:[objectID entity]];
            
            NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForEvaluatedObject]
                                                                        rightExpression:[NSExpression expressionForConstantValue:objectForID]
                                                                               modifier:NSDirectPredicateModifier
                                                                                   type:NSEqualToPredicateOperatorType
                                                                                options:0];
            
            [request setPredicate:predicate];
            
            NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
            if ([results count] > 0 )
            {
                DBUser* user = (DBUser *)[managedObjectContext objectWithID:objectID];
                self.activeUser = user;
            }
        }
    }
}

@synthesize activeUser;

- (void)setActiveUser:(DBUser *)user
{
    activeUser = user;
    
    NSError* error = nil;
    [self.managedObjectContext save:&error];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (activeUser) {
        NSURL *activeUserIDURL = [[activeUser objectID] URIRepresentation];
        NSData *activeUserData = [NSKeyedArchiver archivedDataWithRootObject:activeUserIDURL];
        [userDefaults setObject:activeUserData forKey:kActiveUser];
    } else {
        [userDefaults removeObjectForKey:kActiveUser];
    }
    
    [userDefaults synchronize];
}

- (DBUser *)activeUser
{
    if (!activeUser) {
        [self obtainCurrentUser];
    }
    return activeUser;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "growApp.DataManager" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Inkit" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Inkit.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - DataManager Methods
- (NSManagedObject *)_insert:(NSString *)type {
    return [NSEntityDescription insertNewObjectForEntityForName:type inManagedObjectContext:self.managedObjectContext];
}

- (NSManagedObject *)insert:(NSString *)type {
    __block NSManagedObject* obj = nil;
    [self.managedObjectContext performBlockAndWait:^{
        obj = [self _insert:type];
    }];
    return obj;
}

- (void)insertAsync:(NSString *)type completion:(void (^)(NSManagedObject *))completion {
    [self.managedObjectContext performBlock:^{
        NSManagedObject* obj = [self _insert:type];
        completion(obj);
    }];
}

- (void) _deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext performBlockAndWait:^{
        [self _deleteObject:object];
    }];
}

- (void)deleteObjectAsync:(NSManagedObject *)object completion:(void (^)())completion {
    [self.managedObjectContext performBlock:^{
        [self _deleteObject:object];
        completion();
    }];
}

- (NSArray *)_fetch:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit {
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:type];
    fetchRequest.entity = [NSEntityDescription entityForName:type inManagedObjectContext:self.managedObjectContext];
    fetchRequest.includesSubentities = true;
    fetchRequest.fetchBatchSize = 20;
    if (limit) {
        fetchRequest.fetchLimit = limit;
    }
    if (sort) {
        fetchRequest.sortDescriptors = sort;
    }
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    NSError * error = nil;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSArray *)fetch:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit {
    __block NSArray* result = nil;
    [self.managedObjectContext performBlockAndWait:^{
        result = [self _fetch:type predicate:predicate sort:sort limit:limit];
    }];
    return result;
}

- (void)fetchAsync:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit completion:(void (^)(NSArray *))completion {
    [self.managedObjectContext performBlock:^{
        NSArray* result = [self _fetch:type predicate:predicate sort:sort limit:limit];
        completion(result.firstObject);
    }];
}
//
//- (NSFetchedResultsController* )fetchResultController:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSString *)sort group:(NSString *)group{
//    NSFetchedResultsController* controller = nil;
//    [self.managedObjectContext performBlockAndWait:^{
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        fetchRequest.entity = [NSEntityDescription entityForName:type inManagedObjectContext:self.managedObjectContext];
//        fetchRequest.includesSubentities = true;
//        fetchRequest.fetchBatchSize = 20;
//        NSSortDescriptor *sortDescriptors = [sort];
//        fetchRequest.sortDescriptors = sortDescriptors;
//
//    }];
//
//    return controller;
//}

- (NSManagedObject *)first:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit{
    __block NSArray *result = nil;
    [self.managedObjectContext performBlockAndWait:^{
        result = [self _fetch:type predicate:predicate sort:sort limit:limit];
    }];
    return result.firstObject;
}

- (void)firstAsync:(NSString *)type predicate:(NSPredicate *)predicate sort:(NSArray *)sort limit:(int)limit completion:(void (^)(NSArray *))completion{
    [self.managedObjectContext performBlock:^{
        NSArray* result = [self _fetch:type predicate:predicate sort:sort limit:limit];
        completion (result.firstObject);
    }];
}

- (NSUInteger)_count:(NSString *)type predicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.entity = [NSEntityDescription entityForName:type inManagedObjectContext:self.managedObjectContext];
    fetchRequest.includesSubentities = false;
    if (predicate) {
        fetchRequest.predicate = predicate;
    }
    NSError *error = nil;
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
}

- (NSUInteger)count:(NSString *)type predicate:(NSPredicate *)predicate {
    __block NSUInteger result = 0;
    [self.managedObjectContext performBlockAndWait:^{
        result = [self _count:type predicate:predicate];
    }];
    return result;
}

- (void)countAsync:(NSString *)type predicate:(NSPredicate *)predicate completion:(void (^)(NSUInteger))completion{
    [self.managedObjectContext performBlock:^{
        NSUInteger count = [self _count:type predicate:predicate];
        completion (count);
    }];
}

- (void)_save:(void (^)(void))changes {
    NSError *error = nil;
    if (changes) {
        changes();
    }
    [self.managedObjectContext save:&error];
}

- (void)save:(void (^)(void))changes{
    [self.managedObjectContext performBlockAndWait:^{
        [self _save:^{
            changes();
        }];
    }];
}

- (void)saveAsync:(void (^)(void))changes completion:(void (^)(void))completion {
    [self.managedObjectContext performBlock:^{
        [self _save:^{
            changes();
        }];
        completion();
    }];
}

@end
