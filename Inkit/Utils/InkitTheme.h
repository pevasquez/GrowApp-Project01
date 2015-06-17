//
//  InkitTheme.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InkitTheme : NSObject
+ (UIColor *)getTintColor;
+ (UIColor *)getBaseColor;
+ (UIColor *)getLightBaseColor;
+ (UIColor *)getBackgroundColor;
+ (void)setUpNavigationBarForViewController:(UIViewController *)viewController;
+ (UIColor *)getColorForText;
+ (UIColor *)getColorForPlaceHolderText;

// Comments
+ (UIFont *)getFontForUserName;
+ (UIFont *)getFontForComments;
@end
