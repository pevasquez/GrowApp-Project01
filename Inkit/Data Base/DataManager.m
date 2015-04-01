//
//  DataManager.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 26/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"

@interface DataManager()
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
        AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
    }
    return self;
}
@end
