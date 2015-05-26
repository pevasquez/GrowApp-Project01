//
//  InkitButton.m
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitButton.h"

@interface InkitButton()

@property (strong, nonatomic) UIImageView* iconImageView;
@end
@implementation InkitButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (!self.iconImageView) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + 45);
        [self addSubview:self.iconImageView];
    }
}

- (void)setIconImage:(UIImage *)iconImage
{
    self.iconImageView.image = iconImage;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.iconImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + 45);
}
@end
