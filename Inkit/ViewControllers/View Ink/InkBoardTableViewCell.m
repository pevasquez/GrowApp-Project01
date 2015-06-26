//
//  InkBoardTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 6/26/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkBoardTableViewCell.h"

@implementation InkBoardTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureForInk {
    self.textLabel.text = self.ink.board.boardTitle;
}

@end
