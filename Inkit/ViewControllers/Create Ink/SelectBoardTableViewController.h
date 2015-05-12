//
//  SelectBoardTableViewController.h
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBUser+Management.h"
#import "CreateBoardViewController.h"

@protocol SelectBoardDelegate <NSObject>
- (void)didSelectBoard:(DBBoard *)board;
@end

@interface SelectBoardTableViewController : UITableViewController <CreateBoardDelegate>
@property (strong, nonatomic) DBBoard *selectedBoard;
@property (weak, nonatomic) id <SelectBoardDelegate> delegate;
@end
