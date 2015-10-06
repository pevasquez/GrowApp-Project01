//
//  ViewBoards.m
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewBoardsViewController.h"
#import "BoardViewController.h"
#import "CreateBoardViewController.h"
#import "BoardsCollectionView.h"
#import "BoardCollectionViewCell.h"
#import "AppDelegate.h"
#import "DBBoard+Management.h"

static NSString * const BoardCollectionViewCellIdentifier = @"BoardCollectionViewCell";

@interface ViewBoardsViewController()
@property (strong, nonatomic) NSArray *boardsArray;
@property (weak, nonatomic) IBOutlet BoardsCollectionView *boardsCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ViewBoardsViewController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"My Boards",nil);
    self.activeUser = [DataManager sharedInstance].activeUser;
    [self customizeNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBoards];
}

#pragma mark - CollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.boardsArray count]) {
        self.boardsCollectionView.backgroundView = nil;
        return 1;
    } else {// Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Create your first Board";
        messageLabel.textColor = [InkitTheme getBaseColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.boardsCollectionView.backgroundView = messageLabel;
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.boardsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BoardCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:BoardCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.board = self.boardsArray[indexPath.row];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ViewInksSegue" sender:indexPath];
}

#pragma mark - Get Data Methods
- (void)getBoards {
    [self showActivityIndicator];
    [self.activeUser getBoardsWithCompletionHandler:^(id response, NSError *error) {
        [self hideActitivyIndicator];
        if (error) {
            [self showAlertForMessage:(NSString *)response];
        } else {
            self.boardsArray = (NSArray *)response;
            [self.boardsCollectionView reloadData];
        }
    }];
}

#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[BoardViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        BoardViewController* viewInksViewController = [segue destinationViewController];
        DBBoard* board = self.boardsArray[indexPath.row];
//        viewInksViewController.inksArray = [board getInksFromBoard];
        viewInksViewController.title = board.boardTitle;
        viewInksViewController.board = board;
    }
}

- (IBAction)createBoardButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"CreateBoardSegue" sender:nil];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

#pragma mark - Actitivy Indicator Methods
- (void) showActivityIndicator {
    [GAProgressHUDHelper standarBlankHUD:self.view];
//    self.activityIndicatorView.hidden = NO;
//    [self.activityIndicatorView startAnimating];
}

- (void) hideActitivyIndicator {
    [GAProgressHUDHelper hideProgressHUDinView:self.view];
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)showAlertForMessage:(NSString *)errorMessage {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alert show];
}

@end
