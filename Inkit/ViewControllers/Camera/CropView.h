//
//  CropView.h
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropView : UIView {
    BOOL isResizingBottomRight;
    BOOL isResizingTopLeft;
    BOOL isResizingTopRight;
    BOOL isResizingBottomLeft;
    BOOL isResizingTop;
    BOOL isResizingBottom;
    BOOL isResizingLeft;
    BOOL isResizingRight;
    CGPoint touchStart;
    UIView *leftLine;
    UIView *middleLeftLine;
    UIView *middleRightLine;
    UIView *rightLine;
    UIView *topLine;
    UIView *middleTopLine;
    UIView *middleBottomLine;
    UIView *bottomLine;
    
    UIView *leftTopCorner;
    UIView *topLeftCorner;
    UIView *leftBottomCorner;
    UIView *bottomLeftCorner;
    
    UIView *rightTopCorner;
    UIView *topRightCorner;
    UIView *rightBottomCorner;
    UIView *bottomRightCorner;
}

- (void)updateBounds;

@end
