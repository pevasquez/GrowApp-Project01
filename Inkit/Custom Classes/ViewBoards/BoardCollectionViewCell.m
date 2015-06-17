//
//  BoardCollectionViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "BoardCollectionViewCell.h"
#import "DBInk+Management.h"
#import "InkitTheme.h"
#import "DBImage+Management.h"

@interface BoardCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *boardTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstThumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondThumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdThumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourthThumbnailImageView;

@end
@implementation BoardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [InkitTheme getBaseColor];
    self.mainImageView.clipsToBounds = YES;
    self.firstThumbnailImageView.clipsToBounds = YES;
    self.secondThumbnailImageView.clipsToBounds = YES;
    self.thirdThumbnailImageView.clipsToBounds = YES;
    self.fourthThumbnailImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureForBoard:self.board];
}

- (void)configureForBoard:(DBBoard *)board {
    self.boardTitleLabel.text = board.boardTitle;
    NSArray* inks = board.inks.allObjects;
    if ([inks count]) [((DBInk *)inks[0]).thumbnailImage setInImageView:self.mainImageView];
    if ([inks count] > 1) [((DBInk *)inks[1]).thumbnailImage setInImageView:self.firstThumbnailImageView];
    if ([inks count] > 2)  [((DBInk *)inks[2]).thumbnailImage setInImageView:self.secondThumbnailImageView];
    if ([inks count] > 3)  [((DBInk *)inks[3]).thumbnailImage setInImageView:self.thirdThumbnailImageView];
    if ([inks count] > 4)  [((DBInk *)inks[4]).thumbnailImage setInImageView:self.fourthThumbnailImageView];
}

- (void)prepareForReuse {
    self.board = nil;
    self.mainImageView.image = nil;
    self.firstThumbnailImageView.image = nil;
    self.secondThumbnailImageView.image = nil;
    self.thirdThumbnailImageView.image = nil;
    self.fourthThumbnailImageView.image = nil;
}

- (CGSize)getSizeForBounds:(CGRect)screenBounds
{
    double width = (screenBounds.size.width-12)/2;
    double titleOrigin = 8;
    double titleHeight = 32;
    double mainImageViewHeight = width - 8;
    double thumbnailsHeight = (mainImageViewHeight - 12)/3;
    return CGSizeMake(width, titleOrigin+titleHeight+mainImageViewHeight+thumbnailsHeight+8);
}
@end
