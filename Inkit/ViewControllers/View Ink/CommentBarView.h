//
//  CommentBarView.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileImageView.h"

@class CommentBarView;

@protocol CommentBarViewDelegate <NSObject>
- (void)commentBarView:(CommentBarView *)commentBarView didEnterText:(NSString *)text;
@end

@interface CommentBarView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) id<CommentBarViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
