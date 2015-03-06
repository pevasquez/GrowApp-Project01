//
//  ProfileImageView.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ProfileImageView.h"

@implementation ProfileImageView

- (void)awakeFromNib
{
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.clipsToBounds = YES;
}
@end
