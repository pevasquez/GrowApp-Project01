//
//  RoundedCornerButton.m
//  Inkit
//
//  Created by Cristian Pena on 10/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "RoundedCornerButton.h"

@implementation RoundedCornerButton

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
}

@end
