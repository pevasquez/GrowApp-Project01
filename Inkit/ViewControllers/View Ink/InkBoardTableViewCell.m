//
//  InkBoardTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 6/26/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkBoardTableViewCell.h"

@interface InkBoardTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *boardTitleLabel;

@end

@implementation InkBoardTableViewCell

- (void)configureForInk {
    self.boardTitleLabel.text = [NSString stringWithFormat:@"Board: %@",self.ink.board.boardTitle];
}

@end
