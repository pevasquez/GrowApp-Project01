//
//  FormViewController.m
//  Inkit
//
//  Created by Cristian Pena on 24/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "FormViewController.h"

@implementation FormViewController

- (void)hideKeyboard {
    for (UITextField *textField in self.textFieldsArray) {
        [textField resignFirstResponder];
    }
}

- (void) setTextFieldsEnabled:(BOOL)enabled {
    for (UITextField *textField in self.textFieldsArray) {
        textField.enabled = enabled;
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldsArray.lastObject) {
        [textField resignFirstResponder];
    } else {
        NSUInteger textFieldIndex = [self.textFieldsArray indexOfObject:textField];
        UITextField* nextTextField = [self.textFieldsArray objectAtIndex:textFieldIndex + 1];
        [nextTextField becomeFirstResponder];
    }
    return NO;
}

#pragma mark - Disable button when textfields are empty

// Agregar lógica


#pragma mark - Validation Methods
- (BOOL)isFormValid {
    for (UITextField* textField in self.textFieldsArray) {
        if (textField.text.length == 0) {
            return false;
        }
    }
    return true;
}

#pragma mark - AlertView

- (void)showAlertForMessage:(NSString *)errorMessage {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alert show];
}


@end

