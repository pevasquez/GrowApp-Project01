//
//  ViewBoards.m
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewBoardsViewController.h"
#import "ViewInksViewController.h"
#import "CreateBoardViewController.h"
#import "BoardsCollectionView.h"
#import "BoardCollectionViewCell.h"
#import "AppDelegate.h"
#import "DBBoard+Management.h"
#import "InkitTheme.h"
#import "InkitDataUtil.h"

static NSString * const BoardCollectionViewCellIdentifier = @"BoardCollectionViewCell";

@interface ViewBoardsViewController()
@property (strong, nonatomic) NSArray *boardsArray;
@property (weak, nonatomic) IBOutlet BoardsCollectionView *boardsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *createFirstBoardLabel;

@end
@implementation ViewBoardsViewController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"My Boards",nil);
    if (!self.managedObjectContext) {
        // Get ManagedObjectContext from AppDelegate
        self.managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    }
    if (!self.activeUser) {
        self.activeUser = [InkitDataUtil sharedInstance].activeUser;
    }
    
    [self customizeNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyBoards];
}

#pragma mark - CollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.boardsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BoardCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:BoardCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell configureForBoard:self.boardsArray[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    double width = (screenBounds.size.width-12)/2;
    double mainImageViewOrigin = 28;
    double mainImageViewHeight = width - 8;
    double thumbnailsHeight = (mainImageViewHeight - 12)/4;
    return CGSizeMake(width, mainImageViewOrigin + mainImageViewHeight + thumbnailsHeight + 8);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ViewInksSegue" sender:indexPath];
}

#pragma mark - Get Data Methods
- (void)getMyBoards
{
    [self.activeUser getBoardsWithTarget:self completeAction:@selector(getBoardsCompleteAction) completeError:@selector(getBoardsCompleteError)];
}

- (void)getBoardsCompleteAction
{
    self.boardsArray = [self.activeUser getBoards];
    if ([self.boardsArray count]) {
        self.createFirstBoardLabel.hidden = YES;
    } else {
        self.createFirstBoardLabel.hidden = NO;
    }
    [self.boardsCollectionView reloadData];
}

- (void)getBoardsCompleteError
{

}

#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[ViewInksViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        ViewInksViewController* viewInksViewController = [segue destinationViewController];
        DBBoard* board = self.boardsArray[indexPath.row];
        viewInksViewController.inksArray = [board getInksFromBoard];
        viewInksViewController.title = board.boardTitle;
    }
}

- (IBAction)createBoardButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"CreateBoardSegue" sender:nil];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}
@end
