//
//  BoardCollectionViewCell.h
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBBoard+Management.h"

@interface BoardCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) DBBoard* board;
//- (void)configureForBoard:(DBBoard *)board;
- (CGSize)getSizeForBounds:(CGRect)screenBounds;
@end
