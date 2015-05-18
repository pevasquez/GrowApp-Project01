//
//  TextFieldTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 5/15/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TextFieldTableViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.delegate = self;
    self.textField.text = self.text;
    self.textField.placeholder = self.placeholder;
    self.textField.inputAccessoryView = nil;
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate textFieldTableViewCell:self didFinishEnteringText:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.delegate textFieldTableViewCell:self didFinishEnteringText:textField.text];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellDidBeginEditing:)]) {
        [self.delegate textFieldTableViewCellDidBeginEditing:self];
    }
}

@end
