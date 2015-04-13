//
//  InkActionsTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkActionsTableViewCell.h"
#import "ProfileImageView.h"
#import "DBUser+Management.h"
#import "InkitTheme.h"

@interface InkActionsTableViewCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reInkButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end
@implementation InkActionsTableViewCell
- (void)configureForInk:(DBInk *)ink
{
    DBUser* user = ink.user;
    if (user.userImage) {
        self.userImageView.image = [UIImage imageWithData:user.userImage];
    }
    self.userNameLabel.text = user.name;
    self.cellHeight = self.bounds.size.height;
    [self setLike:NO];
}

- (void)setLike:(BOOL)selected
{
    if (selected) {
        self.likeButton.tintColor = [InkitTheme getTintColor];
    } else {
        self.likeButton.tintColor = [InkitTheme getBaseColor];

    }
}
@end
