//
//  RegisterViewController.h
//  Inkit
//
//  Created by Cristian Pena on 25/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUser+Management.h"

@protocol RegisterDelegate <NSObject>

- (void)registrationComplete;

@end

@interface RegisterViewController : UIViewController
@property (nonatomic, weak) id<RegisterDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary* userDictionary;
@end
