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
#import "DBImage+Management.h"
#import "InkitTheme.h"

@interface InkActionsTableViewCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *reInkButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *reInksLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation InkActionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepareForReuse];
}

- (void)configureForInk
{
    DBUser* user = self.ink.user;
    [user.profilePicThumbnail setInImageView:self.userImageView];
    self.userNameLabel.text = user.fullName;
    self.cellHeight = self.bounds.size.height;
    self.reInksLabel.text = [NSString stringWithFormat:@"%@",self.ink.reInksCount];
    self.likesLabel.text = [NSString stringWithFormat:@"%@",self.ink.likesCount];
    [self setLike:[self.ink.loggedUserLikes boolValue]];
    [self setReInk:[self.ink.loggedUserReInked boolValue]];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.userNameLabel.text = @"";
    self.reInksLabel.text = @"0";
    self.likesLabel.text = @"0";
    self.userImageView.image = nil;
}

- (void)setLike:(BOOL)selected {
    if (selected) {
        self.likeButton.tintColor = [InkitTheme getTintColor];
        self.likesLabel.textColor = [InkitTheme getTintColor];
    } else {
        self.likeButton.tintColor = [InkitTheme getLightBaseColor];
        self.likesLabel.textColor = [InkitTheme getLightBaseColor];
    }
}

- (void)setReInk:(BOOL)selected {
    if (selected) {
        self.reInkButton.tintColor = [InkitTheme getTintColor];
        self.reInksLabel.textColor = [InkitTheme getTintColor];
    } else {
        self.reInkButton.tintColor = [InkitTheme getLightBaseColor];
        self.reInksLabel.textColor = [InkitTheme getLightBaseColor];
    }
}

@end
