//
//  RemoteTableViewController.h
//  Inkit
//
//  Created by Cristian Pena on 2/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h" 

@protocol SelectRemoteDelegate
- (void)didSelectRemote:(NSManagedObject *)remote forType:(NSString *)type;
@end

@interface SelectRemoteViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSManagedObject* selectedRemote;
@property (nonatomic) int cellCount;
@property (nonatomic, weak) id<SelectRemoteDelegate> delegate;

@end
