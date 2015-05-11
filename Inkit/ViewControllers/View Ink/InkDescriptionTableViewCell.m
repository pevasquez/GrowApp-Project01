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
@property (weak, nonatomic) IBOutlet DynamicSizeLabel *inkDescriptionLabel;
@end

@implementation InkDescriptionTableViewCell

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self configureForInk];
//}

- (void)configureForInk
{
    self.inkDescriptionLabel.text = self.ink.inkDescription;
    self.inkDescriptionLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 16;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (!self.cellHeight) {
        self.cellHeight = size.height;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.inkDescriptionLabel.text = nil;
}
- (void)configureForDescription:(NSString *)inkDescription
{
    self.inkDescriptionLabel.text = inkDescription;
    self.inkDescriptionLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 16;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (!self.cellHeight) {
        self.cellHeight = size.height;
    }
}
@end
