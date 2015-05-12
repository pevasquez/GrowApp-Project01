//
//  ViewController.h
//  Tutorial
//
//  Created by María Verónica  Sonzini on 7/5/15.
//  Copyright (c) 2015 María Verónica Sonzini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialPage.h"

@protocol TutorialStepViewControllerDelegate
- (void)didFinishTutorial;
@end

@interface TutorialStepViewController : UIViewController
@property (nonatomic, weak) id <TutorialStepViewControllerDelegate> delegate;
@property (nonatomic, strong) TutorialPage *page;

@end

