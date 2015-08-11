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

@property (strong, nonatomic) NSIndexPath *temporalIndexPath;

@end

@implementation InkImageTableViewCell
- (void)configureForInk:(DBInk *)ink {
    self.ink = ink;
}

- (void)configureForInk {
    self.temporalIndexPath = self.indexPath;
    if (self.bounds.size.width < [UIScreen mainScreen].bounds.size.width/2) {
        [self.ink.thumbnailImage setInImageView:self.inkImageView];
//        [self.ink.thumbnailImage getImageWithCompletion:^(UIImage *image) {
//            if (self.temporalIndexPath == self.indexPath) {
//                self.inkImageView.image = image;
//            }
//        }];
    } else {
        [self.ink.fullScreenImage setInImageView:self.inkImageView];

//        [self.ink.fullScreenImage getImageWithCompletion:^(UIImage *image) {
//            if (self.temporalIndexPath == self.indexPath) {
//                self.inkImageView.image = image;
//            }
//        }];
    }
    self.inkImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.bounds.size.width < [UIScreen mainScreen].bounds.size.width/2) {
        [self.ink.thumbnailImage setInImageView:self.inkImageView];
    } else {
        [self.ink.fullScreenImage setInImageView:self.inkImageView];
    }
    self.inkImageView.clipsToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.inkImageView.image = nil;
    self.temporalIndexPath = nil;
}

- (double)getInkImageHeightForImage:(UIImage *)inkImage {
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
