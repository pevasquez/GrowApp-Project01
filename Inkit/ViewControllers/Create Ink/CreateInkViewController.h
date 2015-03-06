//
//  CreateInkViewController.h
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "EditTextViewController.h"
#import "DBUser+Management.h"

@interface CreateInkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate, EditTextViewDelegate>
@property (strong, nonatomic) UIImage* inkImage;
@property (strong, nonatomic) DBUser* activeUser;
@end
