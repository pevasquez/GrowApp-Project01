//
//  NSDate+Extension.m
//  Inkit
//
//  Created by Cristian Pena on 11/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDate *)fromUnixTimeStamp:(NSString *)timeStamp {

    NSTimeInterval interval= [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    return date;
}
@end
