//
//  UserNameLabel.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "UserNameLabel.h"
#import "InkitTheme.h"

@implementation UserNameLabel

- (void)awakeFromNib
{
    self.font = [InkitTheme getFontForUserName];
}

@end
