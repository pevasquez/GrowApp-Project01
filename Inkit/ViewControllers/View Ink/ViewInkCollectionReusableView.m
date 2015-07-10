//
//  ViewInkCollectionReusableView.m
//  Inkit
//
//  Created by Cristian Pena on 7/10/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInkCollectionReusableView.h"
#import "InkTableView.h"
#import "DBInk+Management.h"

@interface ViewInkCollectionReusableView()
@end
@implementation ViewInkCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ViewInkCollectionReusableView" owner:0 options:nil] objectAtIndex:0];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.inkTableView.ink = self.ink;
}

- (void)setInk:(DBInk *)ink {
    _ink = ink;
    self.inkTableView.ink = self.ink;
}

- (CGFloat)height {
    [self layoutSubviews];
    [self setNeedsLayout];
    return self.inkTableView.contentSize.height;
}
@end
