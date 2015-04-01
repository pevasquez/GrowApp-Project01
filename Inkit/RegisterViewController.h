//
//  RegisterViewController.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 25/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUser+Management.h"

@protocol RegisterDelegate <NSObject>

- (void)registrationCompleteForUser:(DBUser *)user;

@end

@interface RegisterViewController : UIViewController
@property (nonatomic, weak) id<RegisterDelegate> delegate;
@end
