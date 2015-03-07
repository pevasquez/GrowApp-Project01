//
//  CreateInkImageTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CreateInkImageTableViewCell.h"

@implementation CreateInkImageTableViewCell
- (void)configureForImage:(UIImage *)image
{
    self.inkImageView.image = image;
    self.cellHeight = [self getInkImageHeightForImage:image];
}

- (double)getInkImageHeightForImage:(UIImage *)inkImage
{
    CGSize inkImageSize = inkImage.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    double newInkImageHeight = inkImageSize.height * screenSize.width / inkImageSize.width;
    return newInkImageHeight;
}

@end
