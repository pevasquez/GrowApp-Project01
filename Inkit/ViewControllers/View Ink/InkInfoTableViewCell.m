//
//  InkInfoTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 7/10/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkInfoTableViewCell.h"
#import "DBUser+Management.h"

@interface InkInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *reInkButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *reInksLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end
@implementation InkInfoTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self prepareForReuse];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.reInksLabel.text = @"0";
    self.likesLabel.text = @"0";
    [self setLike:false];
    [self setReInk:false];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureForInk];
}

- (void)configureForInk {
    self.reInksLabel.text = [NSString stringWithFormat:@"%@",self.ink.reInksCount];
    self.likesLabel.text = [NSString stringWithFormat:@"%@",self.ink.likesCount];
    [self setLike:[self.ink.loggedUserLikes boolValue]];
    [self setReInk:[self.ink.loggedUserReInked boolValue]];
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
