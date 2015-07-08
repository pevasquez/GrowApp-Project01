//
//  ViewInkViewController.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInkViewController.h"
#import "ViewInksViewController.h"
#import "CreateInkViewController.h"
#import "InkitTabBarController.h"
#import "InkImageTableViewCell.h"
#import "InkDescriptionTableViewCell.h"
#import "InkActionsTableViewCell.h"
#import "InkCommentTableViewCell.h"
#import "InkBoardTableViewCell.h"
#import "ViewInkTableViewCell.h"
#import "CommentsViewController.h"
#import "DataManager.h"
#import "InkitTheme.h"
#import "DBImage+Management.h"
#import "inkitService.h"
#import "ViewInkTableViewCell.h"
#import "ViewImageViewController.h"

static NSString * const InkImageTableViewCellIdentifier = @"InkImageTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";
static NSString * const InkActionsTableViewCellIdentifier = @"InkActionsTableViewCell";
static NSString * const InkBoardTableViewCellIdentifier = @"InkBoardTableViewCell";
static NSString * const InkCommentTableViewCellIdentifier = @"InkCommentTableViewCell";
static NSString * const InkRemoteTableViewCellIdentifier = @"RemoteIdentifier";


typedef enum
{
    kViewInkImage,
    //kInkRemote,
    kViewInkDescription,
    kViewInkActions,
    kViewInkBoard,
    kViewInkComment,
    kViewInkTotalCells
} kViewInkCells;

#define kInkActionsCellHeight   60
#define kInkCommentCellHeight   44

@interface ViewInkViewController()
@property (weak, nonatomic) IBOutlet UITableView *inkTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) InkActionsTableViewCell* actionsCell;

@end

@implementation ViewInkViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeNavigationBar];
    self.title = self.ink.inkDescription;
    [self.inkTableView registerNib:[UINib nibWithNibName:@"InkBoardTableViewCell" bundle:nil] forCellReuseIdentifier:InkBoardTableViewCellIdentifier];
    self.inkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UIViewController* parentViewController = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
    if ([parentViewController isKindOfClass:[CreateInkViewController class]]) {
        self.navigationItem.hidesBackButton = YES;
    }
    
    if ([self.ink.user.userID isEqualToString:[DataManager sharedInstance].activeUser.userID]) {
        self.navigationItem.rightBarButtonItem = self.editButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kViewInkTotalCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
    if([cellIdentifier isEqualToString:InkRemoteTableViewCellIdentifier])
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        cell.textLabel.text = ;
        return cell;
        
    } else if ([cellIdentifier isEqualToString:InkActionsTableViewCellIdentifier]) {
        InkActionsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:InkActionsTableViewCellIdentifier];
       // cell.delegate = self;
        self.actionsCell = cell;
        cell.ink = self.ink;
        return cell;
    } else {
        ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.ink = self.ink;
        return cell;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kViewInkImage:
        {
            CGFloat aspectRatio = [self.ink getImageAspectRatio];
            if (aspectRatio > 0) {
                return tableView.bounds.size.width/aspectRatio;
            } else {
                return 300;
            }
            break;
        }
        case kViewInkDescription:
        {
//            NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
//            ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            [cell configureForInk:self.ink];
//            
//            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
//            [cell setNeedsUpdateConstraints];
//            [cell updateConstraintsIfNeeded];
//            
//            [cell setNeedsLayout];
//            [cell layoutIfNeeded];
//            
//            // Get the actual height required for the cell
//            CGFloat height = cell.cellHeight;
//            height += 1;
            
            return 44.0;
            break;
        }
        case kViewInkActions:
        {
            return kInkActionsCellHeight;
            break;
        }
        case kViewInkComment:
        {
            return kInkCommentCellHeight;
            break;
        }
        default:
            return 44;
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kViewInkComment || indexPath.row == kViewInkBoard || indexPath.row == kViewInkImage) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kViewInkComment) {
        [self performSegueWithIdentifier:@"CommentsSegue" sender:nil];
    } else if (indexPath.row == kViewInkBoard) {
        [self performSegueWithIdentifier:@"ViewBoardSegue" sender:nil];
    } else if (indexPath.row == kViewInkImage) {
        [self performSegueWithIdentifier:@"ZoomImageView" sender:nil];
    }
}

#pragma mark - Helper Methods
- (NSString *)getInkCellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = nil;
    switch (indexPath.row) {
        case kViewInkImage:
        {
            cellIdentifier = InkImageTableViewCellIdentifier;
            break;
        }
        case kViewInkDescription:
        {
            cellIdentifier = InkDescriptionTableViewCellIdentifier;
            break;
        }
        case kViewInkActions:
        {
            cellIdentifier = InkActionsTableViewCellIdentifier;
            break;
        }
        case kViewInkBoard:
        {
            cellIdentifier = InkBoardTableViewCellIdentifier;
            break;
        }
        case kViewInkComment:
        {
            cellIdentifier = InkCommentTableViewCellIdentifier;
            break;
        }
//        case kInkRemote:
//        {
//            cellIdentifier = InkRemoteTableViewCellIdentifier;
//        }
        default:
            break;
    }
    return cellIdentifier;
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
        ViewInksViewController* viewInksViewController = [segue destinationViewController];
        viewInksViewController.board = self.ink.board;
    } else if ([segue.identifier isEqualToString:@"ZoomImageView"]) {
        ViewImageViewController* viewImageViewController = [segue destinationViewController];
        viewImageViewController.inkImage = [self.ink getInkImage];
    }
}


#pragma mark - Edit Text Delegate
- (void)didFinishEnteringText:(NSString *)text {
    [self.tableView reloadData];
}

#pragma mark - Ink Actions Delegate

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"EditInkSegue" sender:nil];
}

- (IBAction)likeButtonPressed:(id)sender
{
    if ([self.ink.loggedUserLikes boolValue]) {
        [self.actionsCell setLike:false];
        [InkitService unlikeInk:self.ink completion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self.actionsCell setLike:true];
                }
            });
        }];
    } else {
        [self.actionsCell setLike:true];
        [InkitService likeInk:self.ink completion:^(id response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self.actionsCell setLike:false];
                }
            });
        }];
    }
}

- (void)likeInkError: (NSString*)error {
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)reInkButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"ReInkSegue" sender:nil];
}


- (IBAction)shareButtonPressed:(id)sender {
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



@end
