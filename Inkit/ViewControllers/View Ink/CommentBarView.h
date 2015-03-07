//
//  CommentBarView.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentBarView;

@protocol CommentBarViewDelegate <NSObject>
- (void)commentBarView:(CommentBarView *)commentBarView didEnterText:(NSString *)text;
@end

@interface CommentBarView : UIView <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) id<CommentBarViewDelegate> delegate;
@end
