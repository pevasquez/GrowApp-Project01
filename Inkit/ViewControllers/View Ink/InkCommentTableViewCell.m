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
- (void)configureForInk:(DBInk *)ink
{
    if ([ink.hasComments count] > 1) {
        self.commentLabel.text = [NSString stringWithFormat:@"%lu Comments", (unsigned long)[ink.hasComments count]];
    } else if ([ink.hasComments count] == 1) {
        self.commentLabel.text = [NSString stringWithFormat:@"%lu Comment", (unsigned long)[ink.hasComments count]];
    } else {
        self.commentLabel.text = @"Add Comment";
    }
    self.cellHeight = self.bounds.size.height;
}
@end
