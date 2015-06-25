//
//  CommentsTableView.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentBarView.h"

@class CommentsTableView;

@protocol CommentsTableViewDelegate <NSObject>

- (void)commentsTableView:(CommentsTableView *)commentsTableView didEnterNewComment:(NSString *)comment;

@end

@interface CommentsTableView : UITableView <CommentBarViewDelegate>
@property (strong, nonatomic) UIView* commentsView;
@property (weak, nonatomic) id<CommentsTableViewDelegate> commentsDelegate;
@property (strong, nonatomic) UITextField* commentsTextField;
- (void)showKeyboard;
@end
