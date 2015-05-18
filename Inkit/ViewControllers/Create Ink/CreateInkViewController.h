//
//  CreateInkViewController.h
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h"


@interface CreateInkViewController : UIViewController 
@property (strong, nonatomic) UIImage* inkImage;
@property (strong, nonatomic) DBInk* editingInk;
@property (nonatomic) BOOL isEditingInk;
@property (nonatomic) BOOL isReInking;
@end
