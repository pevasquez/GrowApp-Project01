//
//  CreateBoardViewController.m
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CreateBoardViewController.h"
#import "EditTextViewController.h"
#import "InkDescriptionTableViewCell.h"
#import "DBBoard+Management.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "InkitTheme.h"
#import "InkitConstants.h"

typedef enum
{
    kCreateBoardTitleIndex,
    kCreateBoardDescriptionIndex,
    kCreateBoardTotalCells
} kCreateBoardCells;

#define kCreateBoardCellHeight            44
static NSString * const CreateBoardTableViewCellIdentifier = @"CreateBoardTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";

@interface CreateBoardViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) DBUser* activeUser;
@property (weak, nonatomic) IBOutlet UITableView *createBoardTableView;
@property (strong, nonatomic) NSMutableArray* stringsArray;
@property (strong, nonatomic) NSMutableDictionary* boardDictionary;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation CreateBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideActivityIndicator];
    self.activeUser = [DataManager sharedInstance].activeUser;
    
    if (self.board) {
        self.title = NSLocalizedString(@"Edit Board",nil);
        self.stringsArray = [[NSMutableArray alloc] initWithObjects:self.board.boardTitle,self.board.boardDescription, nil];
    } else {
        self.title = NSLocalizedString(@"Create Board",nil);
        self.stringsArray = [[NSMutableArray alloc] initWithObjects:@"",@"",nil];
    }
    self.createBoardTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isEditing) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return kCreateBoardTotalCells;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CreateBoardTableViewCellIdentifier];

    if (indexPath.section == 0) {
        if (![self.stringsArray[indexPath.row] isEqualToString:@""]) {
            cell.textLabel.textColor = [InkitTheme getColorForText];
            cell.textLabel.text = self.stringsArray[indexPath.row];
        } else {
            cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
            switch (indexPath.row) {
                case kCreateBoardTitleIndex:
                {
                    cell.textLabel.text = @"Title";
                    break;
                }
                case kCreateBoardDescriptionIndex:
                {
                    cell.textLabel.text = @"Description";
                    break;
                }
                default:
                    break;
            }
        }
    } else {
        cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
        cell.textLabel.text = @"Delete";
    }
    return cell;
}

#pragma mark - TableView Delegte Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.stringsArray[indexPath.row] isEqualToString:@""]) {
        InkDescriptionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:InkDescriptionTableViewCellIdentifier];
        [cell configureForDescription:self.stringsArray[indexPath.row]];
        
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        // Get the actual height required for the cell
        CGFloat height = cell.cellHeight;
        height += 1;
        
        return MAX(height, kCreateBoardCellHeight);
    } else {
        return kCreateBoardCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndexPath = indexPath;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case kCreateBoardTitleIndex:
            case kCreateBoardDescriptionIndex:
            {
                [self performSegueWithIdentifier:@"EditTextSegue" sender:indexPath];
                break;
            }
            default:
                break;
        }
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this board", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil) ,nil];
        [alertView show];
    }
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath *)sender;
        EditTextViewController* editTextViewController = [segue destinationViewController];
        editTextViewController.delegate = self;
        editTextViewController.textString = self.stringsArray[indexPath.row];
    }
}

#pragma mark - Action Methods
- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    if ([self.stringsArray[kCreateBoardTitleIndex] isEqualToString:@""] ||
        [self.stringsArray[kCreateBoardDescriptionIndex] isEqualToString:@""]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Complete the title and description to continue", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alertView show];
    } else {
        if (!self.isEditing) {
            NSDictionary* boardDictionary = @{kBoardTitle:self.stringsArray[kCreateBoardTitleIndex],kBoardDescription:self.stringsArray[kCreateBoardDescriptionIndex]};
            [InkitService postBoard:boardDictionary WithTarget:self completeAction:@selector(boardCreateComplete:) completeError:@selector(boardServiceError:)];
            [self showActivityIndicator];
        } else {
            NSDictionary* boardDictionary = @{kBoardTitle:self.stringsArray[kCreateBoardTitleIndex],kBoardDescription:self.stringsArray[kCreateBoardDescriptionIndex]};
            [self.board updateWithDictionary:boardDictionary Target:self completeAction:@selector(boardUpdateComplete) completeError:@selector(boardServiceError:)];
        }
    }
}

- (void)boardCreateComplete:(DBBoard *)board
{
    [self.delegate boardCreated:board];
    [self.navigationController popViewControllerAnimated:YES];
    [self hideActivityIndicator];
}

- (void)boardUpdateComplete
{
    [self.navigationController popViewControllerAnimated:YES];
    [self hideActivityIndicator];
}

- (void)deleteBoardComplete
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self hideActivityIndicator];
}

- (void)boardServiceError:(NSString *)errorString
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
    [alertView show];
    [self hideActivityIndicator];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EditTextViewController Delegate
- (void)didFinishEnteringText:(NSString *)text
{
    self.stringsArray[self.selectedIndexPath.row] = text;
    [self.createBoardTableView reloadData];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.board deleteWithTarget:self completeAction:@selector(deleteBoardComplete) completeError:@selector(boardServiceError:)];
    }
}

#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator
{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void) hideActivityIndicator
{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
