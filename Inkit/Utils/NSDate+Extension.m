//
//  NSDate+Extension.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 11/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDate *)fromUnixTimeStamp:(NSString *)timeStamp {
    NSLog(@"%@", timeStamp);

    NSTimeInterval interval= [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    return date;
}
@end
