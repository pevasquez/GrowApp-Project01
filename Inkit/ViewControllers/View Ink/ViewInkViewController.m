//
//  ViewInkViewController.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInkViewController.h"
#import "BoardViewController.h"
#import "CreateInkViewController.h"
#import "InkitTabBarController.h"
#import "InkImageTableViewCell.h"
#import "InkDescriptionTableViewCell.h"
#import "InkActionsTableViewCell.h"
#import "InkCommentTableViewCell.h"
#import "InkBoardTableViewCell.h"
#import "ViewInkTableViewCell.h"
#import "CommentsViewController.h"
#import "DBImage+Management.h"
#import "ViewInkTableViewCell.h"
#import "ViewImageViewController.h"
#import "ReportViewController.h"
#import "InkTableView.h"
#import "ViewInkCollectionReusableView.h"

typedef NS_ENUM(NSInteger, IKViewInkCells) {
    kViewInkImage,
    //kInkRemote,
    kViewInkDescription,
    kViewInkActions,
    kViewInkBoard,
    kViewInkComment,
    kViewInkTotalCells
} kInkCell;

typedef NS_ENUM(NSInteger, IKOptionsActionSheet) {
    IKOptionsReportInk,
    IKOptionsEditInk,
    IKOptionsCancel
} IKOptionActionSheet;

#define kInkActionsCellHeight   60
#define kInkCommentCellHeight   44

static NSString * const ViewInkCollectionReusableViewIdentifier = @"ViewInkCollectionReusableView";


@interface ViewInkViewController() <InkTableViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) InkTableView* inkTableView;
@property (strong, nonatomic) UIActionSheet *inkOptionsActionSheet;

@end

@implementation ViewInkViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeNavigationBar];
    self.title = self.ink.inkDescription;
    [self.inksCollectionView registerNib:[UINib nibWithNibName:@"ViewInkCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ViewInkCollectionReusableViewIdentifier];
    UIViewController* parentViewController = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
    
    if ([parentViewController isKindOfClass:[CreateInkViewController class]]) {
        self.navigationItem.hidesBackButton = YES;
    }
    
    self.navigationItem.rightBarButtonItem = self.editButton;

    [self refreshCollectionViewData];
}

- (void)refreshCollectionViewData {
    currentPage = 1;
    [self getMoreInks];
}

- (void)inkTableView:(InkTableView *)inkTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kViewInkComment) {
        [self showCommentInk];
    } else if (indexPath.row == kViewInkBoard) {
        [self showViewBoard];
    } else if (indexPath.row == kViewInkImage) {
        [self showViewImage];
    }
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

#pragma mark - Navigation Methods
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    InkitTabBarController* tabBarController = (InkitTabBarController*)self.tabBarController;
    [tabBarController selectDashboard];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[CommentsViewController class]]) {
        CommentsViewController* commentsViewController = [segue destinationViewController];
        commentsViewController.ink = self.ink;
    } else if ([segue.identifier isEqualToString:@"EditInkSegue"]) {
        CreateInkViewController* createInkViewController = [segue destinationViewController];
        createInkViewController.isEditingInk = true;
        createInkViewController.editingInk = self.ink;
    } else if ([segue.identifier isEqualToString:@"ReInkSegue"]) {
        CreateInkViewController* createInkViewController = [segue destinationViewController];
        createInkViewController.isReInking = true;
        createInkViewController.editingInk = self.ink;
    } else if ([segue.identifier isEqualToString:@"ViewBoardSegue"]) {
        BoardViewController* viewInksViewController = [segue destinationViewController];
        viewInksViewController.board = self.ink.board;
    } else if ([segue.identifier isEqualToString:@"ViewImageSegue"]) {
        ViewImageViewController* viewImageViewController = [segue destinationViewController];
        viewImageViewController.inkImage = [self.ink getInkImage];
    } else if ([segue.identifier isEqualToString:@"ReportInkSegue"]) {
        ReportViewController *reportViewController = [segue destinationViewController];
        reportViewController.ink = self.ink;
    }
}


#pragma mark - Ink Actions Delegate

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    
    [self.inkOptionsActionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)likeButtonPressedForInkTableView:(InkTableView *)inkTableView {
    if ([self.ink.loggedUserLikes boolValue]) {
        [self.inkTableView setLike:false];
        [InkitService unlikeInk:self.ink completion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self.inkTableView setLike:true];
                }
            });
        }];
    } else {
        [self.inkTableView setLike:true];
        [InkitService likeInk:self.ink completion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self.inkTableView setLike:false];
                }
            });
        }];
    }
}

- (void)reInkButtonPressedForInkTableView:(InkTableView *)inkTableView {
    [self showReInk];
}

- (void)shareButtonPressedForInkTableView:(InkTableView *)inkTableView {
    NSString *message = [NSString stringWithFormat:@"Check out the new Ink %@ I've posted",self.ink.inkDescription];
    
    UIImage *image = [self.ink.image getImage];
    
    NSArray *shareItems = nil;
    if (image) {
        shareItems = @[message, image];
    } else {
        shareItems = @[message];
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:shareItems
                                                                             applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)showAlertForMessage:(NSString *)errorMessage {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            ViewInkCollectionReusableView* viewInk = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ViewInkCollectionReusableViewIdentifier forIndexPath:indexPath];
            viewInk.ink = self.ink;
            viewInk.inkTableView.inkTableViewDelegate = self;
            self.inkTableView = viewInk.inkTableView;
            return viewInk;
        }
    } else {
        return [super collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - CollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 0) {
        if ([self.ink getImageAspectRatio] > 0) {
            height = collectionView.bounds.size.width/[self.ink getImageAspectRatio];
        } else {
            height = 300;
        }
        height += 60;
        height += 44*3;
    }
    return CGSizeMake(collectionView.bounds.size.width, height);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == currentPage - 2) && (indexPath.item == ((NSArray *)self.inksArray[indexPath.section]).count - 1) ) {
        [self getMoreInks];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [self showRelatedInkForIndexPath:indexPath];
}

- (void)getMoreInks {
    [InkitService getDashboardInksForPage:currentPage withCompletion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self hideActivityIndicator];
//                [self.refreshControl endRefreshing];
                if (error == nil) {
                    [self getInksComplete:response];
                } else {
                    
                }
            });
        }];
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

#pragma mark - Cover Buttons
- (UIActionSheet *)inkOptionsActionSheet {
    if (!_inkOptionsActionSheet) {
        
        _inkOptionsActionSheet =  [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil];
        
        if ([self.ink.user.userID isEqualToString:[DataManager sharedInstance].activeUser.userID]) {
            [_inkOptionsActionSheet addButtonWithTitle:NSLocalizedString(@"edit", nil)];
        } else {
            [_inkOptionsActionSheet addButtonWithTitle:NSLocalizedString(@"report", nil)];
        }
    }
    return _inkOptionsActionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    IKOptionsActionSheet optionType = [self getOptionTypeForIndex:buttonIndex];
    
    switch (optionType) {
        case IKOptionsReportInk:
            [self showReportInk];
            break;
        case IKOptionsEditInk:
            [self showEditInk];
            break;
        case IKOptionsCancel:
            break;
    }
}

- (IKOptionsActionSheet)getOptionTypeForIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return IKOptionsCancel;
    } else {
        if ([self.ink.user.userID isEqualToString:[DataManager sharedInstance].activeUser.userID]) {
            return IKOptionsEditInk;
        } else {
            return IKOptionsReportInk;
        }
    }
}
- (void)showReportInk {
    [self performSegueWithIdentifier:@"ReportInkSegue" sender:nil];
}

- (void)showEditInk {
    [self performSegueWithIdentifier:@"EditInkSegue" sender:nil];
}

- (void)showReInk {
    [self performSegueWithIdentifier:@"ReInkSegue" sender:nil];
}

- (void)showCommentInk {
    [self performSegueWithIdentifier:@"CommentsSegue" sender:nil];
}

- (void)showViewBoard {
    [self performSegueWithIdentifier:@"ViewBoardSegue" sender:nil];
}

- (void)showViewImage {
    [self performSegueWithIdentifier:@"ViewImageSegue" sender:nil];
}

- (void)showRelatedInkForIndexPath:(NSIndexPath *)indexPath {
    
    ViewInkViewController *relatedInkViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewInkViewController"];
    relatedInkViewController.ink = self.inksArray[indexPath.section][indexPath.item];

    [self.navigationController pushViewController:relatedInkViewController animated:true];
}
@end
