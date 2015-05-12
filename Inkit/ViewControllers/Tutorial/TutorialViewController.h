//
//  PageViewController.h
//  Tutorial
//
//  Created by María Verónica  Sonzini on 7/5/15.
//  Copyright (c) 2015 María Verónica Sonzini. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate
@protocol TutorialViewControllerDelegate
- (void)didFinishTutorial;
@end

@interface TutorialViewController : UIPageViewController
@property (nonatomic, weak) id <TutorialViewControllerDelegate> tutorialDelegate;
@end
