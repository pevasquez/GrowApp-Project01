//
//  ViewInksViewController.h
//  Inkit
//
//  Created by Cristian Pena on 7/10/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewInksViewController;

@protocol ViewInksDelegate <NSObject>
@optional
- (void)viewInksViewController:(ViewInksViewController *)viewInksViewController didScrollToIndexPath:(NSIndexPath *)indexPath;
@end

@interface ViewInksViewController : UIViewController  <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSInteger currentPage;
}

@property (strong, nonatomic) NSMutableArray* inksArray;

@property (weak, nonatomic) IBOutlet UICollectionView *inksCollectionView;

@end
