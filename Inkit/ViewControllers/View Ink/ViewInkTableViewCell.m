//
//  ViewInkTableViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInkTableViewCell.h"


@implementation ViewInkTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureForInk];
}

- (void)configureForInk {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.ink = nil;
}
@end
