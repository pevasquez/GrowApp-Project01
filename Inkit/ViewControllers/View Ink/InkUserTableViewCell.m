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

@interface InkUserTableViewCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
@implementation InkUserTableViewCell

- (void)configureForInk:(DBInk *)ink
{
    self.userNameLabel.text = ink.user.name;
    self.userImageView.image = ink.user.userImage;
}
@end
