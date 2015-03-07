//
//  SelectBoardTableViewController.h
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUser+Management.h"

@protocol SelectBoardDelegate <NSObject>
- (void)boardSelected:(DBBoard *)board;
@end

@interface SelectBoardTableViewController : UITableViewController
@property (strong, nonatomic) DBUser *activeUser;
@property (weak, nonatomic) id <SelectBoardDelegate> delegate;
@end
