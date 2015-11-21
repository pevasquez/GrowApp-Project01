//
//  ViewInkTableViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKInk.h"

@interface ViewInkTableViewCell : UITableViewCell

@property (nonatomic)double cellHeight;
@property (strong, nonatomic) IKInk* ink;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
