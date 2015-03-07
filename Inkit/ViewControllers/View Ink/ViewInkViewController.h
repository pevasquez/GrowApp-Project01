//
//  ViewInkViewController.h
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h"
#import "EditTextViewController.h"

@interface ViewInkViewController : UITableViewController <EditTextViewDelegate>
@property (strong, nonatomic) DBInk* ink;
@end
