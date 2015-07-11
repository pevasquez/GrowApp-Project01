//
//  InkCommentTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkCommentTableViewCell.h"
#import "DBInk+Management.h"

@interface InkCommentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation InkCommentTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.ink.commentsCount.integerValue > 1) {
        self.commentLabel.text = [NSString stringWithFormat:@"%@ Comments", self.ink.commentsCount];
    } else if (self.ink.commentsCount.integerValue == 1) {
        self.commentLabel.text = [NSString stringWithFormat:@"%@ Comment", self.ink.commentsCount];
    } else {
        self.commentLabel.text = @"Add Comment";
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.commentLabel.text = @"";
}

- (void)configureForInk {
    if ([self.ink.comments count] > 1) {
        self.commentLabel.text = [NSString stringWithFormat:@"%lu Comments", (unsigned long)[self.ink.comments count]];
    } else if ([self.ink.comments count] == 1) {
        self.commentLabel.text = [NSString stringWithFormat:@"%lu Comment", (unsigned long)[self.ink.comments count]];
    } else {
        self.commentLabel.text = @"Add Comment";
    }
    self.cellHeight = self.bounds.size.height;
}
@end
