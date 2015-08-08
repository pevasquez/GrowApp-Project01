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

+ (void)logInUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion;

+ (void)logInSocialDictionary:(NSDictionary *)facebookDictionary withCompletion:(ServiceResponse)completion;

+ (void)registerUserDictionary:(NSDictionary *)userDictionary withCompletion:(ServiceResponse)completion;

+ (void)logOutUser:(DBUser *)user withCompletion:(ServiceResponse)completion;

@end
