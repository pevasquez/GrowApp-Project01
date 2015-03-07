//
//  CommentBarView.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommentBarView.h"
#import "InkitTheme.h"

@implementation CommentBarView
- (id)init {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 40);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.textField = [[UITextField alloc]initWithFrame:CGRectInset(frame, 10, 5)];
        self.textField.backgroundColor = [InkitTheme getBackgroundColor];
        self.textField.placeholder = @" Add a comment";
        self.textField.delegate = self;
        [self addSubview:self.textField];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate commentBarView:self didEnterText:textField.text];
    self.textField.text = @"";
    return NO;
}

@end
