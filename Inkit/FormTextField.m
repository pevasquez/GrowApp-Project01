//
//  FormTextField.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 10/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "FormTextField.h"

@implementation FormTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]}];
    self.layer.cornerRadius = 4;
    
}

- (void)didBeginEditing:(NSNotification *)notification {
    if (notification.object == self) {
        self.layer.borderColor = [UIColor colorWithRed:105/255.0 green:176/255.0 blue:231/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 1;
    }
}

- (void)didEndEditing:(NSNotification *)notification {
    if (notification.object == self) {
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
