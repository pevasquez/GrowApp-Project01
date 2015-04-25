//
//  InkImageTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkImageTableViewCell.h"
#import "DBImage+Management.h"

@interface InkImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *inkImageView;
@property (strong, nonatomic) DBInk* ink;
@end

@implementation InkImageTableViewCell
- (void)configureForInk:(DBInk *)ink
{
    self.ink = ink;
}

- (void)layoutSubviews
{
    UIImage* inkImage = [self.ink getInkImage];
    [self.ink.image setInImageView:self.inkImageView];
    self.inkImageView.clipsToBounds = YES;
    self.cellHeight = [self getInkImageHeightForImage:inkImage];

}
- (double)getInkImageHeightForImage:(UIImage *)inkImage
{
    CGSize inkImageSize = inkImage.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    double newInkImageHeight = inkImageSize.height * screenSize.width / inkImageSize.width;
    if (newInkImageHeight != newInkImageHeight) {
        return 300;
    } else {
    return newInkImageHeight;
    }
}

@end
