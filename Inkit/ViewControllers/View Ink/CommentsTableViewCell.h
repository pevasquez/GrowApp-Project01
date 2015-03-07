//
//  CommentsTableViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBComment+Management.h"

@interface CommentsTableViewCell : UITableViewCell
@property (nonatomic)double cellHeight;
- (void)configureForComment:(DBComment *)comment;
@end
