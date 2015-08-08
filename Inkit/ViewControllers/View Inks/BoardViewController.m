//
//  ViewInksViewController.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "BoardViewController.h"
#import "ViewInkViewController.h"
#import "CreateBoardViewController.h"
#import "InkCollectionViewCell.h"
#import "WaterfallLayout.h"

static NSString * const InkCollectionViewCellIdentifier = @"InkCollectionViewCell";

@interface BoardViewController ()
//@property (weak, nonatomic) IBOutlet UICollectionView *inksCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) BOOL isEditing;
@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.board.user.userID isEqualToString:[DataManager sharedInstance].activeUser.userID]) {
        self.navigationItem.rightBarButtonItem = self.editButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.title = self.board.boardTitle;
    self.inksArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getInks];
}

- (void)getInks {
    if (self.board) {
        [self showActivityIndicator];
        [self.board getInksWithCompletion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideActitivyIndicator];
                if (error == nil) {
//                    [self getInksComplete:response];
                    [self.inksArray addObject:[self.board getInksFromBoard]];
                    [self.inksCollectionView reloadData];
                } else {
                    [self showAlertForMessage:response];
                }
            });
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
        
    }
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:indexPath];
}

#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[ViewInkViewController class]] && [sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        ViewInkViewController* viewInkViewController = [segue destinationViewController];
        viewInkViewController.ink = self.inksArray[indexPath.section][indexPath.row];
    } else if ([[segue destinationViewController] isKindOfClass:[CreateBoardViewController class]]) {
        CreateBoardViewController* createBoardViewController = [segue destinationViewController];
        createBoardViewController.board = self.board;
        createBoardViewController.isEditing = YES;
    }
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"EditBoardSegue" sender:nil];
}

#pragma mark - Actitivy Indicator Methods
- (void) showActivityIndicator {
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void) hideActitivyIndicator {
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)showAlertForMessage:(NSString *)errorMessage {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alert show];
}

@end
