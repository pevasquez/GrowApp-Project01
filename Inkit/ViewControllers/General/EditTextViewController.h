//
//  EditTextViewController.h
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditTextViewDelegate <NSObject>

- (void)didFinishEnteringText:(NSString *)text;

@end
@interface EditTextViewController : UIViewController

@property (weak, nonatomic) id<EditTextViewDelegate> delegate;
@property (strong, nonatomic) NSString *textString;
@end
