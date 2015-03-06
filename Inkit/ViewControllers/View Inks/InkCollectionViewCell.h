//
//  InkCollectionViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBInk+Management.h"

@interface InkCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>
- (void)configureForInk:(DBInk *)ink;
- (double)getCellHeight;
@end
