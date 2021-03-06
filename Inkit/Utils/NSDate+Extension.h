//
//  NSDate+Extension.h
//  Inkit
//
//  Created by Cristian Pena on 11/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Extension)
+ (NSDate *)fromUnixTimeStamp:(NSString *)timeStamp;
- (NSString *)relativeDateString;
@end
