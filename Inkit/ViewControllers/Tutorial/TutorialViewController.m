//
//  PageViewController.m
//  Tutorial
//
//  Created by Cristian Pena on 7/5/15.
//  Copyright (c) 2015 María Verónica Sonzini. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialStepViewController.h"
#import "TutorialPage.h"

@interface TutorialViewController () <UIPageViewControllerDataSource, TutorialStepViewControllerDelegate>

@property (strong, nonatomic) NSArray *pages;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
  [super viewDidLoad];

    self.pages = [TutorialPage allPages];
    TutorialStepViewController *stepVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialStepViewController"];
    stepVC.page = self.pages [0];
    stepVC.delegate = self;
    
    [self setViewControllers:@[stepVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.dataSource = self;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    TutorialStepViewController *oldVC = (TutorialStepViewController *)viewController;
    int newIndex = oldVC.page.index + 1;
    if (newIndex > self.pages.count - 1) return nil;
    
    TutorialStepViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialStepViewController"];
    newVC.page = self.pages[newIndex];
    newVC.delegate = self;
    return newVC;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    TutorialStepViewController *oldVC = (TutorialStepViewController *)viewController;
    int newIndex = oldVC.page.index - 1;
    if (newIndex < 0) return nil;
    
    TutorialStepViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialStepViewController"];
    newVC.page = self.pages[newIndex];
    return newVC;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    
    //    return 0;
    //    Para agregar los puntitos por default descomentar lo siguiente y comentar el return anterior.
    
    return self.pages.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    
    TutorialStepViewController *vc = (TutorialStepViewController *)pageViewController.viewControllers[0];
    return vc.page.index;
}
// MARK:- TutorialStepViewControllerDelegate
- (void)didFinishTutorial
{
    [self.tutorialDelegate didFinishTutorial];
}
@end
