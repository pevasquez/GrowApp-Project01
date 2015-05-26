//
//  CreateBoardViewController.m
//  Inkit
//
//  Created by Cristian Pena on 12/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CreateBoardViewController.h"
#import "TextFieldTableViewCell.h"
#import "InkDescriptionTableViewCell.h"
#import "DBBoard+Management.h"
#import "AppDelegate.h"
#import "DataManager.h"
#import "InkitTheme.h"
#import "InkitConstants.h"
#import "GAProgressHUDHelper.h"

typedef enum
{
    kCreateBoardTitleIndex,
    kCreateBoardDescriptionIndex,
    kCreateBoardTotalCells
} kCreateBoardCells;

#define kCreateBoardCellHeight            44
static NSString * const CreateBoardTableViewCellIdentifier = @"CreateBoardTableViewCell";
static NSString * const TextFieldTableViewCellIdentifier = @"TextFieldTableViewCell";

@interface CreateBoardViewController () <UIAlertViewDelegate, TextFieldTableViewCellDelegate>
@property (strong, nonatomic) DBUser* activeUser;
@property (weak, nonatomic) IBOutlet UITableView *createBoardTableView;
@property (strong, nonatomic) NSMutableArray* stringsArray;
@property (strong, nonatomic) NSArray* placeholdersArray;
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
    self.placeholdersArray = @[@"Title",@"Description"];
    [self customizeTableView];
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
    UITableViewCell* cell = nil;

    if (indexPath.section == 0) {
        TextFieldTableViewCell* textFieldCell = [tableView dequeueReusableCellWithIdentifier:TextFieldTableViewCellIdentifier];
        textFieldCell.placeholder = NSLocalizedString(self.placeholdersArray[indexPath.row],nil);;
        textFieldCell.text = self.stringsArray[indexPath.row];
        textFieldCell.indexPath = indexPath;
        textFieldCell.delegate = self;
        cell = textFieldCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CreateBoardTableViewCellIdentifier];
        cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
        cell.textLabel.text = @"Delete";
    }
    return cell;
}

#pragma mark - TableView Delegte Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCreateBoardCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this board", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil) ,nil];
        [alertView show];
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

#pragma mark - TextFieldTableViewCell Delegate
- (void)textFieldTableViewCellDidFinishEnteringText:(TextFieldTableViewCell *)cell {
    [self.createBoardTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)textFieldTableViewCell:(TextFieldTableViewCell *)cell didEnterText:(NSString *)text {
    
    if (text.length > 0) {
        self.stringsArray[cell.indexPath.row] = text;
    } else {
        self.stringsArray[cell.indexPath.row] = @"";
    }
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
    [GAProgressHUDHelper standarBlankHUD:self.view];
}

- (void) hideActivityIndicator
{
    [GAProgressHUDHelper hideProgressHUDinView:self.view];
}

#pragma mark - UIHelpers
- (void)customizeTableView {
    [self.createBoardTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TextFieldTableViewCellIdentifier];
    
    self.createBoardTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
