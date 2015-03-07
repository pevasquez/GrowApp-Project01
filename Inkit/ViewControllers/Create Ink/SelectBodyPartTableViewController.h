//
//  SelectBodyPartTableViewController.h
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h"

@interface SelectBodyPartTableViewController : UITableViewController <UISearchBarDelegate>
@property (strong, nonatomic)DBInk* editingInk;
@end
