//
//  NSDate+Extension.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 11/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDate (Extension)
+ (NSDate *)fromUnixTimeStamp:(NSString *)timeStamp;
@end
