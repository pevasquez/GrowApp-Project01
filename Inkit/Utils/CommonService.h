//
//  CommonService.h
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonService : NSObject

+ (void)getBodyPartsWithCompletion:(ServiceResponse)completion;

+ (void)getTattooTypesWithCompletion:(ServiceResponse)completion;

+ (void)getTattooStylesWithCompletion:(ServiceResponse)completion;

@end
