//
//  CropView.h
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropViewDelegate <NSObject>
- (CGRect)getCanvasForCropView;
- (BOOL)view:(UIView*)view willPanOutsideRect:(CGRect)rect withTranslation:(CGPoint)translation;
- (BOOL)view:(UIView*)view willScaleOutsideRect:(CGRect)rect withTranslation:(CGPoint)translation;

@end

@interface CropView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id<CropViewDelegate> delegate;

@end
