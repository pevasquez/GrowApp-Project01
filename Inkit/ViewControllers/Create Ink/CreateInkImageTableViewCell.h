//
//  CreateInkImageTableViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateInkImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *inkImageView;
@property (strong, nonatomic) UIImage *inkImage;
@property (nonatomic)double cellHeight;
- (void)configureForImage:(UIImage *)image;

@end
