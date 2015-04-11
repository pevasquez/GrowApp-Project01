//
//  CommonService.h
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonService : NSObject
+ (NSError *)getBodyPartsWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)getTattooTypesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
+ (NSError *)getTattooStylesWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
@end
