//
//  CreateBoardViewController.h
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTextViewController.h"
#import "DBUser+Management.h"
#import "DBBoard+Management.h"

@protocol CreateBoardDelegate <NSObject>

- (void)boardCreated:(DBBoard *)board;
@end

@interface CreateBoardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,EditTextViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) DBUser* activeUser;
@property (strong, nonatomic) DBBoard* board;
@property (nonatomic) BOOL isEditing;
@property (weak, nonatomic) id<CreateBoardDelegate> delegate;
@end
