//
//  CommentsTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "ProfileImageView.h"
#import "DBUser+Management.h"
#import "DynamicSizeLabel.h"

@interface CommentsTableViewCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet DynamicSizeLabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentFromDateLabel;

@end
@implementation CommentsTableViewCell
- (void)configureForComment:(DBComment *)comment
{
    self.userImage.image = [UIImage imageWithData:comment.user.userImage];
    self.userName.text = comment.user.name;
    self.commentLabel.text = comment.text;
    double leading = self.commentLabel.frame.origin.x;
    
    self.commentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - leading-8;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (!self.cellHeight) {
        self.cellHeight = size.height;
    }
}
@end
