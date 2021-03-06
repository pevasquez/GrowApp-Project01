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
#import "GADBannerCollectionReusableView.h"
#import "ViewInkViewController.h"
#import "AppDelegate.h"

static NSString * const InkCollectionViewCellIdentifier = @"InkCollectionViewCell";
static NSString * const BannerCollectionViewCellIdentifier = @"BannerCollectionViewCell";


@interface BrowseViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
//@property (weak, nonatomic) IBOutlet UICollectionView *browseCollectionView;
//@property (strong, nonatomic) NSMutableArray* inksArray;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (nonatomic) BOOL isSearching;
@end

@implementation BrowseViewController


#pragma mark - Life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeNavigationBar];
    [self setupCollectionView];
    [self refreshCollectionViewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.selectedIndexPath) {
        [self.inksCollectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
    }
}

#pragma mark - Get Ink methods
- (void)setupCollectionView {
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [InkitTheme getTintColor];
    [self.refreshControl addTarget:self action:@selector(refreshCollectionViewData) forControlEvents:UIControlEventValueChanged];
    [self.inksCollectionView addSubview:self.refreshControl];
}

- (void)refreshCollectionViewData {
    currentPage = 1;
    [self showActivityIndicator];
    [self getMoreInks];
}

- (void)getMoreInks {
    if (self.isSearching) {
        [InkitService getInksForSearchString:self.searchBar.text andPage:currentPage withCompletion:^(id response, NSError *error) {
            [self hideActivityIndicator];
            if(self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
            if (!error) {
                [self getInksComplete:response];
            } else {
                
            }
        }];
    } else {
        [InkitService getDashboardInksForPage:currentPage withCompletion:^(id response, NSError *error) {
            [self hideActivityIndicator];
            if(self.refreshControl.isRefreshing){
                [self.refreshControl endRefreshing];
            }
            if (!error) {
                [self getInksComplete:response];
            } else {
                
            }
        }];
    }
}

- (void)getInksComplete:(NSArray *)inksArray {
    if(inksArray.count > 0) {
        NSMutableArray* newArray = [[NSMutableArray alloc] initWithArray:inksArray];
        if (currentPage == 1) {
            self.inksArray = [[NSMutableArray alloc] init];
        } else {
            NSMutableArray* lastArray = (NSMutableArray *)self.inksArray[currentPage-2];
            if (lastArray.count % 2) {
                if (inksArray.count > 0) {
                    [lastArray addObject:inksArray.firstObject];
                    [newArray removeObject:newArray.firstObject];
                }
            }
        }
        [self.inksArray addObject:newArray];
        currentPage++;
        [self.inksCollectionView reloadData];
    } else {
        if (currentPage == 1 && self.isSearching) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Your search did not return any data" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    self.selectedIndexPath = indexPath;
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == ((NSArray *)self.inksArray[indexPath.section]).count - 1) {
        [self getMoreInks];
    }
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
    [self refreshCollectionViewData];
    [UIView animateWithDuration:0.3 animations:^{
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
    [self refreshCollectionViewData];
}

#pragma mark - Navigation Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[ViewInkViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        ViewInkViewController* viewInkViewController = [segue destinationViewController];
        viewInkViewController.ink = self.inksArray[indexPath.section][indexPath.row];
    }
}

#pragma mark - Activity Indicator Methods
- (void)showActivityIndicator {
    [GAProgressHUDHelper browseProgressHUD:self.view];
}

- (void)hideActivityIndicator {
    [GAProgressHUD hideHUDForView:self.view animated:true];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    self.title = NSLocalizedString(@"Browse",nil);
    self.navigationItem.rightBarButtonItem = self.searchButton;
    [InkitTheme setUpNavigationBarForViewController:self];
}

@end
