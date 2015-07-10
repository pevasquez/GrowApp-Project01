//
//  InkTableView.h
//  Inkit
//
//  Created by Cristian Pena on 7/9/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBInk, InkTableView;

@protocol InkTableViewDelegate <NSObject>

- (void)inkTableView:(InkTableView *)inkTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface InkTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DBInk* ink;

@property (weak, nonatomic) id <InkTableViewDelegate> inkTableViewDelegate;

@end
