//
//  FormViewController.h
//  Inkit
//
//  Created by Cristian Pena on 24/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *textFieldsArray;

- (void)hideKeyboard;
- (void)disableTextFields;
- (void)enableTextFields;
- (BOOL)isFormValid;
- (void)showAlertForMessage:(NSString *)errorMessage;
@end

