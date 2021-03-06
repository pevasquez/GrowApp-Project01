//
//  CommentsTableView.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommentsTableView.h"

@interface CommentsTableView()
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@end
@implementation CommentsTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [InkitTheme getBackgroundColor];
}

// Override canBecomeFirstResponder
// to allow this view to be a responder
-(BOOL)canBecomeFirstResponder {
    return YES;
}

// Override inputAccessoryView to use
// an instance of KeyboardBar
- (UIView *)inputAccessoryView {
    if(!_inputAccessoryView) {
        CommentBarView* commentBarView = [[CommentBarView alloc] init];
        self.commentsTextField = commentBarView.textField;
        commentBarView.delegate = self;
        _inputAccessoryView = commentBarView;
    }
    return _inputAccessoryView;
}

- (void)showKeyboard {
    [self.commentsTextField becomeFirstResponder];
}

#pragma mark - CommentBarView Delegate
- (void)commentBarView:(CommentBarView *)commentBarView didEnterText:(NSString *)text {
    [self.commentsDelegate commentsTableView:self didEnterNewComment:text];
}

@end
