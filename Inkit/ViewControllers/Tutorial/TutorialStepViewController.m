//
//  ViewController.m
//  Tutorial
//
//  Created by Cristian Pena on 7/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "TutorialStepViewController.h"
#import <UIKit/UIKit.h>

@interface TutorialStepViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation TutorialStepViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.page == nil) {
        self.page = [TutorialPage allPages][0];
    }
    
    if (self.page == [TutorialPage allPages].lastObject) {
        [self.actionButton setTitle:@"Start Using App" forState:UIControlStateNormal];
    } else {
        [self.actionButton setTitle:@"Skip" forState:UIControlStateNormal];
    }
    
    self.bgImageView.image = self.page.bgImage;
    self.bgImageView.clipsToBounds = true;
    
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:10.f];
    [style setAlignment:NSTextAlignmentCenter];
}

- (IBAction)actionButtonPressed:(UIButton *)sender {
    [self.delegate didFinishTutorial];
}

@end
