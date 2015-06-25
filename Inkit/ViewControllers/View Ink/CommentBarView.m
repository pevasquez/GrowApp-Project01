//
//  CommentBarView.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommentBarView.h"
#import "InkitTheme.h"
#import "DataManager.h"
#import "DBImage+Management.h"

@implementation CommentBarView
- (id)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentBarView" owner:0 options:nil] objectAtIndex:0];
    if(self) {
        [self customizeView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"CommentBarView" owner:0 options:nil] objectAtIndex:0];
    if(self) {
        [self customizeView];
    }
    return self;
}

//- (void)didMoveToSuperview {
//    [super didMoveToSuperview];
//    [self.textField becomeFirstResponder];
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self.textField becomeFirstResponder];
//}

- (void)customizeView {
    self.backgroundColor = [UIColor whiteColor];
    self.textField.backgroundColor = [InkitTheme getBackgroundColor];
    self.textField.placeholder = @" Add a comment";
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 5;
    self.textField.clipsToBounds = true;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [[DataManager sharedInstance].activeUser.profilePicThumbnail setInImageView:self.profileImageView];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate commentBarView:self didEnterText:textField.text];
    self.textField.text = @"";
    return NO;
}

@end
