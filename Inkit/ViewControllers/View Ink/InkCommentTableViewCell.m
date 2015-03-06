//
//  InkCommentTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkCommentTableViewCell.h"

@interface InkCommentTableViewCell()
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;


@end
@implementation InkCommentTableViewCell
- (void)configureForInk:(DBInk *)ink
{
    self.cellHeight = self.bounds.size.height;
}
@end
