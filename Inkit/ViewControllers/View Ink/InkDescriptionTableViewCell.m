//
//  InkDescriptionTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkDescriptionTableViewCell.h"
#import "DynamicSizeLabel.h"

@interface InkDescriptionTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *inkDescriptionLabel;

@end

@implementation InkDescriptionTableViewCell

- (void)configureForInk {
    if (self.bounds.size.width < [UIScreen mainScreen].bounds.size.width/2) {
        self.inkDescriptionLabel.font = [self.inkDescriptionLabel.font fontWithSize:12];
    } else {
        self.inkDescriptionLabel.font = [self.inkDescriptionLabel.font fontWithSize:17];
    }
    self.inkDescriptionLabel.text = self.ink.inkDescription;
    self.inkDescriptionLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 16;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (!self.cellHeight) {
        self.cellHeight = size.height;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureForInk];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.inkDescriptionLabel.text = nil;
}
@end
