//
//  InkitServiceV2.h
//  Inkit
//
//  Created by Cristian Pena on 2/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBUser+Management.h"

@interface UserService : NSObject

+ (NSError *)logInUserDictionary:(NSDictionary *)userDictionary withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (NSError *)registerUser:(DBUser *)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;

+ (NSError *)logOutUser:(DBUser *)user withTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;


@end
