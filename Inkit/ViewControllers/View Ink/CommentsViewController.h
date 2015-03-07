//
//  CommentsViewController.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h"
#import "CommentsTableView.h"

@interface CommentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,CommentsTableViewDelegate>
@property (strong, nonatomic) DBInk* ink;
@end
