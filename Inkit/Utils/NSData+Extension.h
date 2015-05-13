//
//  NSMutableData+Extension.h
//  Inkit
//
//  Created by Cristian Pena on 5/13/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)
+ (NSMutableData *)fromDictionary:(NSDictionary *)dataDictionary andBoundary:(NSString *)boundary;
@end
