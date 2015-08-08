//
//  EditImageViewController.h
//  Inkit
//
//  Created by Cristian Pena on 3/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropView.h"

@protocol EditImageDelegate

- (void)didEditImage:(UIImage *)image;

@end

@interface EditImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) id <EditImageDelegate> delegate;
@property (strong, nonatomic) UIImage* imageToEdit;
@property (nonatomic) BOOL isEditing;

@end
