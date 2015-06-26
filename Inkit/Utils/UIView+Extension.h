//
//  UIView+Extension.h
//  Inkit
//
//  Created by Cristian Pena on 6/26/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    None = 0,
    iPhone4 = 1,
    iPhone5 = 2,
    iPhone6 = 3,
    iPhone6Plus = 4,
    iPhone6Zoomed = 5,
    iPhone6PlusZoomed = 6
} DeviceType;

@interface UIView (Extension)
+ (CGSize)screenSize;
+ (DeviceType)deviceType;
@end
