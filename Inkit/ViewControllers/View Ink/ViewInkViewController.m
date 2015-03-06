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
#import "InkitTheme.h"

static NSString * const InkImageTableViewCellIdentifier = @"InkImageTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";
static NSString * const InkActionsTableViewCellIdentifier = @"InkActionsTableViewCell";
static NSString * const InkCommentTableViewCellIdentifier = @"InkCommentTableViewCell";

typedef enum
{
    kInkImage,
    kInkDescription,
    kInkActions,
//    kInkComment,
    kInkTotalCells
} kViewInkCells;

#define kInkActionsCellHeight   60
#define kInkCommentCellHeight   44

@interface ViewInkViewController()
@property (strong, nonatomic) IBOutlet UITableView *inkTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

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

#pragma mark UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kInkTotalCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
    ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configureForInk:self.ink];
    return cell;
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
            
            return height;
            break;
        }
        case kInkActions:
        {
            return kInkActionsCellHeight;
            break;
        }
//        case kInkComment:
//        {
//            return kInkCommentCellHeight;
//            break;
//        }
        default:
            return 0;
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

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
//        case kInkComment:
//        {
//            cellIdentifier = InkCommentTableViewCellIdentifier;
//            break;
//        }
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

@end
