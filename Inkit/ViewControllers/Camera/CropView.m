//
//  CropView.m
//  CropView
//
//  Created by Cristian Pena on 6/26/15.
//  Copyright (c) 2015 Cristian Pena. All rights reserved.
//

#import "CropView.h"

#define kResizeThumbSize 20
#define kCornerSize 20
#define kCornerWidth 8
#define kLineWidth 1
#define kBorderWidth 2
@implementation CropView

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self initCropView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initCropView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initCropView];
}

- (void)initCropView {
    self.backgroundColor = [UIColor clearColor];
    leftTopCorner = [[UIView alloc] init];
    leftTopCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:leftTopCorner];
    topLeftCorner = [[UIView alloc] init];
    topLeftCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:topLeftCorner];
    rightTopCorner = [[UIView alloc] init];
    rightTopCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:rightTopCorner];
    topRightCorner = [[UIView alloc] init];
    topRightCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:topRightCorner];
    
    leftBottomCorner = [[UIView alloc] init];
    leftBottomCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:leftBottomCorner];
    bottomLeftCorner = [[UIView alloc] init];
    bottomLeftCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:bottomLeftCorner];
    rightBottomCorner = [[UIView alloc] init];
    rightBottomCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:rightBottomCorner];
    bottomRightCorner = [[UIView alloc] init];
    bottomRightCorner.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:bottomRightCorner];
    
    middleLeftLine = [[UIView alloc] init];
    middleLeftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:middleLeftLine];
    middleRightLine = [[UIView alloc] init];
    middleRightLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:middleRightLine];
    middleTopLine = [[UIView alloc] init];
    middleTopLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:middleTopLine];
    middleBottomLine = [[UIView alloc] init];
    middleBottomLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:middleBottomLine];
    
    leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:leftLine];
    rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:rightLine];
    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawGrid];
}

- (void)drawRect:(CGRect)rect {
    [self drawGrid];
}

- (void)drawGrid {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat widthAlpha = [self getAlphaForSize:width];
    CGFloat heightAlpa = [self getAlphaForSize:height];
    leftLine.frame = CGRectMake(0, 0, kBorderWidth, height);
    rightLine.frame = CGRectMake(width - kBorderWidth, 0, kBorderWidth, height);
    bottomLine.frame = CGRectMake(0, height - kBorderWidth, width, kBorderWidth);
    topLine.frame = CGRectMake(0, 0, width, 2);
    
    middleLeftLine.frame = CGRectMake(width/3, 0, kLineWidth, height);
    middleLeftLine.alpha = widthAlpha;
    middleRightLine.frame = CGRectMake(width*2/3, 0, kLineWidth, height);
    middleRightLine.alpha = widthAlpha;
    middleTopLine.frame = CGRectMake(0, height/3, width, kLineWidth);
    middleTopLine.alpha = heightAlpa;
    middleBottomLine.frame = CGRectMake(0, height*2/3, width, kLineWidth);
    middleBottomLine.alpha = heightAlpa;
    
    leftTopCorner.frame = CGRectMake(- kBorderWidth, -kBorderWidth, kCornerWidth, kCornerSize);
    topLeftCorner.frame = CGRectMake(- kBorderWidth, -kBorderWidth, kCornerSize, kCornerWidth);
    rightTopCorner.frame = CGRectMake(width - kCornerWidth + kBorderWidth, -kBorderWidth, kCornerWidth, kCornerSize);
    topRightCorner.frame = CGRectMake(width - kCornerSize + kBorderWidth, -kBorderWidth, kCornerSize, kCornerWidth);
    
    leftBottomCorner.frame = CGRectMake(- kBorderWidth, height- kCornerSize + kBorderWidth, kCornerWidth, kCornerSize);
    bottomLeftCorner.frame = CGRectMake(- kBorderWidth, height - kCornerWidth + kBorderWidth, kCornerSize, kCornerWidth);
    rightBottomCorner.frame = CGRectMake(width - kCornerWidth + kBorderWidth, height- kCornerSize + kBorderWidth, kCornerWidth, kCornerSize);
    bottomRightCorner.frame = CGRectMake(width - kCornerSize + kBorderWidth, height - kCornerWidth + kBorderWidth, kCornerSize, kCornerWidth);
    
}

- (CGFloat)getAlphaForSize:(CGFloat)size {
    
    if (size < 2 * kResizeThumbSize) {
        return 0;
    } else if (size > 4 * kResizeThumbSize) {
        return 1;
    } else {
        return (size - 2 * kResizeThumbSize) / (2 * kResizeThumbSize);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchStart = [[touches anyObject] locationInView:self];
    isResizingBottomRight = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    isResizingTopLeft = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    isResizingTopRight = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    isResizingBottomLeft = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
    isResizingTop = (touchStart.y < kResizeThumbSize);
    isResizingBottom = (self.bounds.size.height - touchStart.y < kResizeThumbSize);
    isResizingLeft = (touchStart.x < kResizeThumbSize);
    isResizingRight = (self.bounds.size.width - touchStart.x < kResizeThumbSize);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint previous = [[touches anyObject] previousLocationInView:self];
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
    
    // get the frame values so we can calculate changes below
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGRect newRect = CGRectZero;
    
    
    if (isResizingBottomRight) {
        if (x + deltaWidth + width > self.superview.frame.size.width)
            deltaWidth = self.superview.frame.size.width - x - width;
        if (y + deltaHeight + height > self.superview.frame.size.height)
            deltaHeight = self.superview.frame.size.height - y - height;
        if (height + deltaHeight < 2 * kCornerSize)
            deltaHeight = 2 * kCornerSize - height;
        if (width + deltaWidth < 2 * kCornerSize)
            deltaWidth = 2 * kCornerSize - width;
        newRect = CGRectMake(x, y, width + deltaWidth, height + deltaHeight);
    } else if (isResizingTopLeft) {
        if (x + deltaWidth < 0)
            deltaWidth = x;
        if (y + deltaHeight < 0)
            deltaHeight = y;
        if (width - deltaWidth < 2 * kCornerSize)
            deltaWidth = 2 * kCornerSize - width;
        if (height - deltaHeight < 2 * kCornerSize)
            deltaHeight = 2 * kCornerSize - height;
        newRect = CGRectMake(x + deltaWidth, y + deltaHeight, width - deltaWidth, height - deltaHeight);
    } else if (isResizingTopRight) {
        if (y + deltaHeight < 0)
            deltaHeight = y;
        if (x + deltaWidth + width > self.superview.frame.size.width)
            deltaWidth = self.superview.frame.size.width - x - width;
        if (height - deltaHeight < 2 * kCornerSize)
            deltaHeight = 2 * kCornerSize - height;
        if (width + deltaWidth < 2 * kCornerSize)
            deltaWidth = 2 * kCornerSize - width;
        newRect = CGRectMake(x, y + deltaHeight, width + deltaWidth, height-deltaHeight);
    } else if (isResizingBottomLeft) {
        if (x + deltaWidth < 0)
            deltaWidth = x;
        if (y + deltaHeight + height > self.superview.frame.size.height)
            deltaHeight = self.superview.frame.size.height - y - height;
        if (width - deltaWidth < 2 * kCornerSize)
            deltaWidth = 2 * kCornerSize - width;
        if (height + deltaHeight < 2 * kCornerSize)
            deltaHeight = 2 * kCornerSize - height;
        newRect = CGRectMake(x + deltaWidth, y, width - deltaWidth, height+deltaHeight);
    } else if (isResizingTop) {
        if (y + deltaHeight < 0)
            deltaHeight = y;
        if (height - deltaHeight < 2 * kCornerSize)
            deltaHeight = 2 * kCornerSize - height;
        newRect = CGRectMake(x, y + deltaHeight, width, height - deltaHeight);
    } else if (isResizingBottom) {
        if (y + deltaHeight + height > self.superview.frame.size.height)
            deltaHeight = self.superview.frame.size.height - y - height;
        if (height + deltaHeight < 2 * kCornerSize)
            deltaHeight = 2 * kCornerSize - height;
        newRect = CGRectMake(x, y, width, height + deltaHeight);
    } else if (isResizingLeft) {
        if (x + deltaWidth < 0)
            deltaWidth = x;
        if (width - deltaWidth < 2 * kCornerSize)
            deltaWidth = 2 * kCornerSize - width;
        newRect = CGRectMake(x + deltaWidth, y, width - deltaWidth, height);
    } else if (isResizingRight) {
        if (x + deltaWidth + width > self.superview.frame.size.width)
            deltaWidth = self.superview.frame.size.width - x - width;
        if (width + deltaWidth < 2 * kCornerSize)
            deltaWidth = 2 * kCornerSize - width;
        newRect = CGRectMake(x, y, width + deltaWidth, height);
    } else {
        // not dragging from a corner -- move the view
        if (x + deltaWidth < 0)
            deltaWidth = x;
        if (y + deltaHeight < 0)
            deltaHeight = y;
        if (x + deltaWidth + width > self.superview.frame.size.width)
            deltaWidth = self.superview.frame.size.width - x - width;
        if (y + deltaHeight + height > self.superview.frame.size.height)
            deltaHeight = self.superview.frame.size.height - y - height;
        newRect = CGRectMake(x + deltaWidth, y + deltaHeight, width, height);
    }
    self.frame = newRect;
    [self drawGrid];
}

@end
