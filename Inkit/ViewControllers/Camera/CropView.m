//
//  CropView.m
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CropView.h"
#define kResizeThumbSize 30
@implementation CropView

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.superview];
    CGPoint touchStart = [recognizer locationInView:self];
//    CGRect editingImageFrame = [self.delegate getCanvasForCropView];
//    if (locationInView.x < margin) {
//        CGPoint origin = CGPointMake(self.frame.origin.x - translation.x, self.frame.origin.y) ;
//        CGSize newSize = self.bounds.size;
//        recognizer.view.frame = CGRectMake(origin.x, origin.y, newSize.width, newSize.height);
//
//    } else if ([self.delegate view:self willPanOutsideRect:editingImageFrame withTranslation:translation]) {
//        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
//                                             recognizer.view.center.y + translation.y);
//        [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
//    }

    BOOL isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    BOOL isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    BOOL isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    BOOL isResizingLL = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
    
    // get the frame values so we can calculate changes below
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (isResizingLR) {
        self.frame = CGRectMake(x, y, touchStart.x+translation.x, touchStart.y+translation.x);
    } else if (isResizingUL) {
        self.frame = CGRectMake(x+translation.x, y+translation.y, width-translation.x, height-translation.y);
    } else if (isResizingUR) {
        self.frame = CGRectMake(x, y+translation.y, width+translation.x, height-translation.y);
    } else if (isResizingLL) {
        self.frame = CGRectMake(x+translation.x, y, width-translation.x, height+translation.y);
    } else {
        // not dragging from a corner -- move the view
        self.center = CGPointMake(self.center.x + translation.x,
                                  self.center.y + translation.y);
    }
}

@end
