//
//  ViewInksViewController.h
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewInksViewController.h"
#import "DBBoard+Management.h"

@interface BoardViewController : ViewInksViewController
@property (strong, nonatomic) DBBoard* board;
@end
