//
//  RemoteTableViewController.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 2/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h" 


@interface SelectRemoteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int cellCount;
@property (strong, nonatomic)DBInk* editingInk;


@end
