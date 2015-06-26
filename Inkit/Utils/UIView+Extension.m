//
//  UIView+Extension.m
//  Inkit
//
//  Created by Cristian Pena on 6/26/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (DeviceType)deviceType {
    CGSize screen = [UIView screenSize];
    if (screen.width <= 320) {
        if (screen.height < 568) {
            return iPhone4;
        } else {
            return iPhone5;
        }
    } else if (screen.width <= 375) {
        if ([UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale) {
            return iPhone6Zoomed;
        } else {
            return iPhone6;
        }
    } else {
        if ([UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale) {
            return iPhone6PlusZoomed;
        } else {
            return iPhone6Plus;
        }
    }
}

@end
