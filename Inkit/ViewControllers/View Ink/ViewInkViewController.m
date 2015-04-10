//
//  ViewInkViewController.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "ViewInkViewController.h"
#import "CreateInkViewController.h"
#import "InkitTabBarController.h"
#import "InkImageTableViewCell.h"
#import "InkDescriptionTableViewCell.h"
#import "InkActionsTableViewCell.h"
#import "InkCommentTableViewCell.h"
#import "ViewInkTableViewCell.h"
#import "CommentsViewController.h"
#import "InkitDataUtil.h"
#import "InkitTheme.h"


static NSString * const InkImageTableViewCellIdentifier = @"InkImageTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";
static NSString * const InkActionsTableViewCellIdentifier = @"InkActionsTableViewCell";
static NSString * const InkCommentTableViewCellIdentifier = @"InkCommentTableViewCell";
static NSString * const InkRemoteTableViewCellIdentifier = @"RemoteIdentifier";


typedef enum
{
    kInkImage,
    kInkRemote,
    kInkDescription,
    kInkActions,
    kInkComment,
    kInkTotalCells
} kViewInkCells;

#define kInkActionsCellHeight   60
#define kInkCommentCellHeight   44

@interface ViewInkViewController()
@property (strong, nonatomic) IBOutlet UITableView *inkTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation ViewInkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.ink.inkDescription;
    [self customizeNavigationBar];
    self.inkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UIViewController* parentViewController = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)];
    if ([parentViewController isKindOfClass:[CreateInkViewController class]]) {
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kInkTotalCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
    if([cellIdentifier isEqualToString:InkRemoteTableViewCellIdentifier])
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.textLabel.text = @"prueba";
        return cell;
        
    } else {
    ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configureForInk:self.ink];
    return cell;
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kInkImage:
        case kInkDescription:
        {
            NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
            ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell configureForInk:self.ink];
            
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            
            // Get the actual height required for the cell
            CGFloat height = cell.cellHeight;
            
            // Add an extra point to the height to account for the cell separator, which is added between the bottom
            // of the cell's contentView and the bottom of the table view cell.
            height += 1;
            
            return MAX(height,10);
            break;
        }
        case kInkActions:
        {
            return kInkActionsCellHeight;
            break;
        }
        case kInkComment:
        {
            return kInkCommentCellHeight;
            break;
        }
        default:
            return 44;
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kInkComment) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kInkComment) {
        [self performSegueWithIdentifier:@"CommentsSegue" sender:nil];
    }
}

#pragma mark - Helper Methods
- (NSString *)getInkCellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = nil;
    switch (indexPath.row) {
        case kInkImage:
        {
            cellIdentifier = InkImageTableViewCellIdentifier;
            break;
        }
        case kInkDescription:
        {
            cellIdentifier = InkDescriptionTableViewCellIdentifier;
            break;
        }
        case kInkActions:
        {
            cellIdentifier = InkActionsTableViewCellIdentifier;
            break;
        }
        case kInkComment:
        {
            cellIdentifier = InkCommentTableViewCellIdentifier;
            break;
        }
        case kInkRemote:
        {
            cellIdentifier = InkRemoteTableViewCellIdentifier;
        }
        default:
            break;
    }
    return cellIdentifier;
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

#pragma mark - Navigation Methods
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    InkitTabBarController* tabBarController = (InkitTabBarController*)self.tabBarController;
    [tabBarController selectDashboard];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[CommentsViewController class]]) {
        CommentsViewController* commentsViewController = [segue destinationViewController];
        commentsViewController.ink = self.ink;
    } else if ([[segue destinationViewController] isKindOfClass:[CreateInkViewController class]]) {
        CreateInkViewController* createInkViewController = [segue destinationViewController];
        createInkViewController.editing = true;
        createInkViewController.editingInk = self.ink;
    }
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"EditInkSegue" sender:nil];
}

#pragma mark - Edit Text Delegate
- (void)didFinishEnteringText:(NSString *)text
{
    [self.ink addCommentWithText:text forUser:[InkitDataUtil sharedInstance].activeUser];
    [self.tableView reloadData];
}

@end
