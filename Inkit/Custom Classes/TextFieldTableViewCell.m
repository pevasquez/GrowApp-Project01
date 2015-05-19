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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    self.text = textField.text;
    [self.delegate textFieldTableViewCell:self didEnterText:textField.text];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.delegate textFieldTableViewCellDidBeginEditing:self];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldTableViewCellDidBeginEditing:)]) {
        [self.delegate textFieldTableViewCellDidBeginEditing:self];
    }
}

@end
