//
//  EditImageViewController.h
//  Inkit
//
//  Created by Cristian Pena on 3/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropView.h"

@interface EditImageViewController : UIViewController <UIScrollViewDelegate,CropViewDelegate>
@property (strong, nonatomic) UIImage* imageToEdit;

@end
