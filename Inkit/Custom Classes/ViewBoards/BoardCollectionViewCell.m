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

- (void)awakeFromNib
{
    self.backgroundColor = [InkitTheme getBaseColor];
    self.mainImageView.clipsToBounds = YES;
    self.firstThumbnailImageView.clipsToBounds = YES;
    self.secondThumbnailImageView.clipsToBounds = YES;
    self.thirdThumbnailImageView.clipsToBounds = YES;
    self.fourthThumbnailImageView.clipsToBounds = YES;
}

- (void)configureForBoard:(DBBoard *)board
{
    self.boardTitleLabel.text = board.boardTitle;
    NSArray* inks = board.inks.allObjects;
    
    if ([inks count]) [((DBInk *)inks[0]).image setInImageView:self.mainImageView];
    else self.mainImageView.image = nil;
    if ([inks count] > 1) [((DBInk *)inks[1]).image setInImageView:self.firstThumbnailImageView];
    else self.firstThumbnailImageView.image = nil;
    if ([inks count] > 2)  [((DBInk *)inks[2]).image setInImageView:self.secondThumbnailImageView];
    else self.secondThumbnailImageView.image = nil;
    if ([inks count] > 3)  [((DBInk *)inks[3]).image setInImageView:self.thirdThumbnailImageView];
    else self.thirdThumbnailImageView.image = nil;
    if ([inks count] > 4)  [((DBInk *)inks[4]).image setInImageView:self.fourthThumbnailImageView];
    else self.fourthThumbnailImageView.image = nil;
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
