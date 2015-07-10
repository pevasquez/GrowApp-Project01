//
//  ViewInkCollectionReusableView.h
//  Inkit
//
//  Created by Cristian Pena on 7/10/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBInk,InkTableView;

@interface ViewInkCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) DBInk* ink;
@property (weak, nonatomic) IBOutlet InkTableView *inkTableView;
@property (nonatomic) CGFloat height;
@end
