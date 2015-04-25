//
//  SelectBoardTableViewController.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SelectBoardTableViewController.h"
#import "DBBoard+Management.h"
#import "InkitTheme.h"

static NSString * const BoardTableViewCellIdentifier = @"BoardTableViewCell";

@interface SelectBoardTableViewController ()
@property (strong, nonatomic) NSArray* boardsArray;
@property (strong, nonatomic) IBOutlet UITableView *boardsTableView;
@end

@implementation SelectBoardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select Board",nil);
    [self customizeNavigationBar];
    [self customizeTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyBoards];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.boardsArray count]) {
        self.boardsTableView.backgroundView = nil;
        return 1;
    } else {// Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Create your first Board";
        messageLabel.textColor = [InkitTheme getBaseColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.boardsTableView.backgroundView = messageLabel;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.boardsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BoardTableViewCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    DBBoard* board = self.boardsArray[indexPath.row];
    cell.textLabel.text = board.boardTitle;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate boardSelected:self.boardsArray[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get Data Methods
- (void)getMyBoards
{
    [self.activeUser getBoardsWithTarget:self completeAction:@selector(getBoardsCompleteAction) completeError:@selector(getBoardsCompleteError)];
}

- (void)getBoardsCompleteAction
{
    self.boardsArray = [self.activeUser getBoards];
    [self.boardsTableView reloadData];
}

- (void)getBoardsCompleteError
{
    
}

#pragma mark - Create Board Delegate
- (void)boardCreated:(DBBoard *)board;
{
    [self.delegate boardSelected:board];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Methods
- (IBAction)createBoardButtonPressed:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"CreateBoardSegue" sender:nil];
}

#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[CreateBoardViewController class]]) {
        CreateBoardViewController* createBoardViewController = [segue destinationViewController];
        createBoardViewController.delegate = self;
    }
}
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (void)customizeTableView
{
    self.boardsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


@end
