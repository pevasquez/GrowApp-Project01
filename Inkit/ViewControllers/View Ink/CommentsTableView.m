//
//  CommentsTableView.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommentsTableView.h"
#import "InkitTheme.h"

@interface CommentsTableView()
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@end
@implementation CommentsTableView

- (void)awakeFromNib
{
    self.backgroundColor = [InkitTheme getBackgroundColor];
}
// Override canBecomeFirstResponder
// to allow this view to be a responder
- (bool) canBecomeFirstResponder {
    return true;
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

#pragma mark - CommentBarView Delegate
- (void)commentBarView:(CommentBarView *)commentBarView didEnterText:(NSString *)text
{
    [self.commentsDelegate commentsTableView:self didEnterNewComment:text];
}

@end
