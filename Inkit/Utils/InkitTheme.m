//
//  InkitTheme.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitTheme.h"

@implementation InkitTheme
+ (UIColor *)getTintColor
{
    return [UIColor colorWithRed:218.0/255.0 green:33.0/255.0 blue:40.0/255.0 alpha:1];
}

+ (UIColor *)getBaseColor
{
    return [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1];
}

+ (UIColor *)getBackgroundColor
{
    return [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
}

+ (void)setUpNavigationBarForViewController:(UIViewController *)viewController;
{
    [viewController.navigationController setNavigationBarHidden:NO animated:NO];
    [viewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [viewController.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [viewController.navigationController.navigationBar setTintColor:[InkitTheme getTintColor]];
    UIFont* permanentMarker = [UIFont fontWithName:@"PermanentMarker" size:24.0f];
    NSDictionary* attributesDictionary = @{NSForegroundColorAttributeName:[InkitTheme getBaseColor], NSFontAttributeName: permanentMarker};
    viewController.navigationController.navigationBar.titleTextAttributes = attributesDictionary;
}

+ (UIColor *)getColorForText
{
    return [UIColor blackColor];
}

+ (UIColor *)getColorForPlaceHolderText
{
    return [UIColor grayColor];
}

+ (UIFont *)getFontForUserName
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
}

+ (UIFont *)getFontForComments
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
}
@end
