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

@interface InkActionsTableViewCell : ViewInkTableViewCell
- (void)setLike:(BOOL)selected;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end
