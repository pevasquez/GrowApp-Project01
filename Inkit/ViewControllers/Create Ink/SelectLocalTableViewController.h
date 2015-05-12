//
//  SelectBodyPartTableViewController.h
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h"
// Delegate
@protocol SelectLocalDelegate
- (void)didSelectLocals:(NSArray *)locals forType:(NSString *)type;
@end
@interface SelectLocalTableViewController : UITableViewController <UISearchBarDelegate>
@property (strong, nonatomic) NSArray* localsArray;
@property (strong, nonatomic)NSMutableArray *selectedLocalsArray;
@property (nonatomic, weak) id<SelectLocalDelegate> delegate;

@end
