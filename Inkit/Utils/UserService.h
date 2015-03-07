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
+ (NSError *)logInUser:(DBUser *)user AndPassword:(NSString *)password WithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
@end
