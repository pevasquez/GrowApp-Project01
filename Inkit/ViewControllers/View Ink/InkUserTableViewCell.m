//
//  InkUserTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkUserTableViewCell.h"
#import "ProfileImageView.h"
#import "DBUser+Management.h"
#import "DBImage+Management.h"

@interface InkUserTableViewCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
@implementation InkUserTableViewCell

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self configureForInk];
//}

- (void)configureForInk
{
    self.userNameLabel.text = self.ink.user.fullName;
    [self.ink.user.profilePicThumbnail setInImageView:self.userImageView];
}
@end
