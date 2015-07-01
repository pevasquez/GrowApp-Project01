//
//  RWTCenteredScrollView.m
//  CenteredImageScroller
//
//  Created by Main Account on 4/26/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "CenteredScrollView.h"

@implementation CenteredScrollView

- (void)layoutSubviews {
  [super layoutSubviews];
  [self centerContent];
}

- (void)centerContent {

  if (self.delegate && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
  
    UIView *viewToCenter = [self.delegate viewForZoomingInScrollView:self];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = viewToCenter.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
      frameToCenter.origin.x =(boundsSize.width - frameToCenter.size.width) / 2;
    } else {
      frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
      frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
      frameToCenter.origin.y = 0;
    }
    
    viewToCenter.frame = frameToCenter;
  
  }

}


@end
