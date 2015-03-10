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
#import "InkitDataUtil.h"
#import "InkitTheme.h"

typedef enum
{
    kBoardTitle,
    kBoardDescription,
    //kInkCategory,
    //kInkBodyPart,
    kCreateBoardTotal
} kCreateBoardCells;

#define kCreateBoardCellHeight            44
static NSString * const CreateBoardTableViewCellIdentifier = @"CreateBoardTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";

@interface CreateBoardViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *createBoardTableView;
@property (strong, nonatomic) NSMutableArray* stringsArray;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation CreateBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.managedObjectContext) {
        // Get ManagedObjectContext from AppDelegate
        self.managedObjectContext = ((AppDelegate*)([[UIApplication sharedApplication] delegate] )).managedObjectContext;
    }
    if (!self.activeUser) {
        self.activeUser = [InkitDataUtil sharedInstance].activeUser;
    }
    
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
        return kCreateBoardTotal;
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
                case kBoardTitle:
                {
                    cell.textLabel.text = @"Title";
                    break;
                }
                case kBoardDescription:
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
            case kBoardDescription:
            case kBoardTitle:
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
    if ([self.stringsArray[kBoardTitle] isEqualToString:@""] ||
        [self.stringsArray[kBoardDescription] isEqualToString:@""]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Complete the title and description to continue", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
        [alertView show];
    } else {
        if (!self.isEditing) {
            DBBoard * board = [self.activeUser createBoardWithTitle:self.stringsArray[kBoardTitle] AndDescription:self.stringsArray[kBoardDescription]];
            [board postWithTarget:self completeAction:@selector(boardCreateComplete) completeError:@selector(boardCreateError)];
            [self.delegate boardCreated:board];
        } else {
            self.board.boardTitle = self.stringsArray[kBoardTitle];
            self.board.boardDescription = self.stringsArray[kBoardDescription];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)boardCreateComplete
{
}

- (void)boardCreateError
{
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
        [self.board deleteBoard];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
