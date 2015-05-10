//
//  BrowseViewController.m
//  Inkit
//
//  Created by Cristian Pena on 11/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "BrowseViewController.h"
#import "DBInk+Management.h"
#import "InkCollectionViewCell.h"
#import "ViewInkViewController.h"
#import "AppDelegate.h"
#import "InkitTheme.h"
#import "InkitService.h"

static NSString * const InkCollectionViewCellIdentifier = @"InkCollectionViewCell";


@interface BrowseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *browseCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray* inksArray;

@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Browse",nil);
    
    [self customizeNavigationBar];
    
    [self showActivityIndicator];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [InkitService getDashboardInksWithTarget:self completeAction:@selector(getInksComplete:) completeError:@selector(getInksError:)];
}


- (void)getInksComplete:(NSArray *)inksArray
{
    self.inksArray = inksArray;
    [self.browseCollectionView reloadData];
    [self hideActivityIndicator];
}

- (void)getInksError:(NSString *)errorString
{
    [self hideActivityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.inksArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InkCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:InkCollectionViewCellIdentifier forIndexPath:indexPath];
    DBInk* ink = self.inksArray[indexPath.row];
    [cell configureForInk:ink];
    return cell;
}

#pragma mark - CollectionView Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    double width = (screenBounds.size.width-12)/2;
    return CGSizeMake(width, 360);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:indexPath];
}


#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[ViewInkViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        ViewInkViewController* viewInkViewController = [segue destinationViewController];
        viewInkViewController.ink = self.inksArray[indexPath.row];;
    }
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void) hideActivityIndicator
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}


@end
