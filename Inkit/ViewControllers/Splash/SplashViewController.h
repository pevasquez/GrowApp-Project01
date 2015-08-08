//
//  SplashViewController.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate
@protocol SplashViewControllerDelegate

- (void)splashScreenDidFinishedLoading;
- (void)splashScreenDidFailToLogUser;

@end

@interface SplashViewController : UIViewController

@property (nonatomic, weak) id<SplashViewControllerDelegate> delegate;

@end
