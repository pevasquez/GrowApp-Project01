//
//  UserTypeViewController.h
//  Inkit
//
//  Created by Cristian Pena on 25/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate
@protocol UserTypeDelegate
- (void)didSelectUserType:(NSString *)userType;
@end

@interface UserTypeViewController : UIViewController

@property (nonatomic, weak) id<UserTypeDelegate> delegate;
@property (nonatomic, strong) NSString* selectedString;
@end
