//
//  ViewController.h
//  Tutorial
//
//  Created by Cristian Pena on 7/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
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

