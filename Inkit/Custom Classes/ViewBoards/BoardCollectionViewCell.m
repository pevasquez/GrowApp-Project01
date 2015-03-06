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
    
    if ([inks count]) self.mainImageView.image = [inks[0] getInkImage];
    else self.mainImageView.image = nil;
    if ([inks count] > 1) self.firstThumbnailImageView.image = [inks[1] getInkImage];
    else self.firstThumbnailImageView.image = nil;
    if ([inks count] > 2) self.secondThumbnailImageView.image = [inks[2] getInkImage];
    else self.secondThumbnailImageView.image = nil;
    if ([inks count] > 3) self.thirdThumbnailImageView.image = [inks[3] getInkImage];
    else self.thirdThumbnailImageView.image = nil;
    if ([inks count] > 4) self.fourthThumbnailImageView.image = [inks[4] getInkImage];
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
