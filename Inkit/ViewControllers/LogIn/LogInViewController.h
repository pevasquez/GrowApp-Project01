//
//  LogInViewController.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"


// Delegate
@protocol LogInViewControllerDelegate

- (void)logInDidFinishedLoading;

@end

@interface LogInViewController : FormViewController
@property (nonatomic, weak) id<LogInViewControllerDelegate> delegate;

@end

