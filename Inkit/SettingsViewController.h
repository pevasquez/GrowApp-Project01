//
//  Settings.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 27/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate
@protocol SettingsDelegate
- (void)didSelectSettings:(NSString *)settings;
@end

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) id<SettingsDelegate> delegate;
@property (nonatomic, strong) NSString* selectedString;
@end
