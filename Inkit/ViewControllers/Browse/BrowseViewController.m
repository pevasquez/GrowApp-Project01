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
#import "GAProgressHUDHelper.h"


static NSString * const InkCollectionViewCellIdentifier = @"InkCollectionViewCell";


@interface BrowseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate> {
    NSInteger currentPage;
}
@property (weak, nonatomic) IBOutlet UICollectionView *browseCollectionView;
@property (strong, nonatomic) NSArray* inksArray;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;
@property (nonatomic) BOOL isSearching;
@end

@implementation BrowseViewController


#pragma mark - Life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationBar];
    [self setupTableView];
    [self refreshCollectionViewData];
    [self showActivityIndicator];
    [self getMoreInks];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Get Ink methods
- (void)setupTableView {
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [InkitTheme getTintColor];
    [self.refreshControl addTarget:self action:@selector(refreshCollectionViewData) forControlEvents:UIControlEventValueChanged];
    [self.browseCollectionView addSubview:self.refreshControl];
}

- (void)refreshCollectionViewData {
    currentPage = 1;
    [self getMoreInks];
}

- (void)getMoreInks {
    if (self.isSearching) {
        [InkitService getInksForSearchString:self.searchBar.text andPage:currentPage withTarget:self completeAction:@selector(getInksComplete:) completeError:@selector(getInksError:)];
    } else {
        [InkitService getDashboardInksForPage:currentPage withTarget:self completeAction:@selector(getInksComplete:) completeError:@selector(getInksError:)];
    }
}

- (void)getInksComplete:(NSArray *)inksArray {
    [self.refreshControl endRefreshing];
    if (currentPage == 1) {
        self.inksArray = [[NSArray alloc] init];
    }
    self.inksArray = [self.inksArray arrayByAddingObjectsFromArray:inksArray];
    currentPage++;
    [self.browseCollectionView reloadData];
    [self hideActivityIndicator];
}

- (void)getInksError:(NSString *)errorString {
    [self.refreshControl endRefreshing];
    [self hideActivityIndicator];
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.inksArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InkCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:InkCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.ink = self.inksArray[indexPath.item];
    if (indexPath.item == self.inksArray.count - 1) {
        [self getMoreInks];
    }
    return cell;
}

#pragma mark - CollectionView Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    double width = (screenBounds.size.width-12)/2;
    return CGSizeMake(width, 344);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:indexPath];
}

#pragma mark - Search Methods
- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.searchButton.tintColor = [self.searchButton.tintColor colorWithAlphaComponent:0];
        self.searchBar.alpha = 1.0;
        self.navigationItem.titleView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.navigationItem.rightBarButtonItem = nil;
        self.searchBar.alpha = 0.0;
        self.navigationItem.titleView = self.searchBar;
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationItem.titleView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.searchBar becomeFirstResponder];
        }];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    self.isSearching = false;
    [self showActivityIndicator];
    [self refreshCollectionViewData];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.navigationItem.titleView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         self.navigationItem.rightBarButtonItem = self.searchButton;
                         self.navigationItem.titleView = nil;
                         self.navigationItem.title = NSLocalizedString(@"Browse",nil);
                         [self customizeNavigationBar];
                         self.navigationItem.titleView.alpha = 0.0;
                         [UIView animateWithDuration:0.5 animations:^{
                             self.searchButton.tintColor = [self.searchButton.tintColor colorWithAlphaComponent:1.0];
                             self.navigationItem.titleView.alpha = 1.0;
                         } completion:nil];
                     }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    UIButton *cancelButton = [searchBar valueForKey:@"_cancelButton"];
    if ([cancelButton respondsToSelector:@selector(setEnabled:)]) {
        cancelButton.enabled = YES;
    }
    self.isSearching = true;
    [self showActivityIndicator];
    [self refreshCollectionViewData];
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[ViewInkViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        ViewInkViewController* viewInkViewController = [segue destinationViewController];
        viewInkViewController.ink = self.inksArray[indexPath.row];;
    }
}

#pragma mark - Activity Indicator Methods

- (void) showActivityIndicator {
    [GAProgressHUDHelper browseProgressHUD:self.view];
}

- (void) hideActivityIndicator {
    [GAProgressHUD hideHUDForView:self.view animated:true];
}

#pragma mark - Appearence Methods

- (void)customizeNavigationBar {
    self.title = NSLocalizedString(@"Browse",nil);
    self.navigationItem.rightBarButtonItem = self.searchButton;
    [InkitTheme setUpNavigationBarForViewController:self];
}

@end
