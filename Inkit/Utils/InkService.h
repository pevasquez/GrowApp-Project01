//
//  InkService.h
//  Inkit
//
//  Created by Cristian Pena on 10/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBUser+Management.h"
#import "DBInk+Management.h"
#import "DBBoard+Management.h"

@interface InkService : NSObject
+ (NSError *) createInk:(DBInk *)ink forUser:(DBUser *)user inBoard:(DBBoard *)board withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

@end
