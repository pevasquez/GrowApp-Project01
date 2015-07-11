//
//  InkActionsTableViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewInkTableViewCell.h"
#import "DBInk+Management.h"

@class InkActionsTableViewCell;

@protocol InkActionsDelegate <NSObject>
@optional
- (void)likeButtonPressedForInkActionsTableViewCell:(InkActionsTableViewCell *)inkActionsTableViewCell;
- (void)reInkButtonPressedForInkActionsTableViewCell:(InkActionsTableViewCell *)inkActionsTableViewCell;
- (void)shareButtonPressedForInkActionsTableViewCell:(InkActionsTableViewCell *)inkActionsTableViewCell;
@end

@interface InkActionsTableViewCell : ViewInkTableViewCell
@property (weak, nonatomic) id <InkActionsDelegate> delegate;
- (void)setLike:(BOOL)liked;
- (void)setReInk:(BOOL)reInked;
@end
