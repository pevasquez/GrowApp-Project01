//
//  SelectBoardTableViewController.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SelectBoardTableViewController.h"
#import "DBBoard+Management.h"

static NSString * const BoardTableViewCellIdentifier = @"BoardTableViewCell";

@interface SelectBoardTableViewController ()
@property (strong, nonatomic) NSArray* boardsArray;
@property (strong, nonatomic) IBOutlet UITableView *boardsTableView;
@property (strong, nonatomic) DBUser* activeUser;
@end

@implementation SelectBoardTableViewController


#pragma mark - Life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select Board",nil);
    self.activeUser = [DataManager sharedInstance].activeUser;
    [self customizeNavigationBar];
    [self customizeTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMyBoards];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.boardsArray count]) {
        self.boardsTableView.backgroundView = nil;
        return 1;
    } else {
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

    return [self.boardsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BoardTableViewCellIdentifier forIndexPath:indexPath];
    DBBoard* board = self.boardsArray[indexPath.row];
    cell.textLabel.text = board.boardTitle;
    if (self.selectedBoard == board) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectBoard:self.boardsArray[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get Data Methods
- (void)getMyBoards {
    [self.activeUser getBoardsWithCompletionHandler:^(id response, NSError *error) {
        if (error) {
            [self showAlertForMessage:(NSString *)response];
        } else {
            self.boardsArray = (NSArray *)response;
            [self.boardsTableView reloadData];
        }
    }];
}

#pragma mark - Create Board Delegate
- (void)boardCreated:(DBBoard *)board; {
    [self.delegate didSelectBoard:board];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action Methods
- (IBAction)createBoardButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"CreateBoardSegue" sender:nil];
}

#pragma mark - Navigation Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[CreateBoardViewController class]]) {
        CreateBoardViewController* createBoardViewController = [segue destinationViewController];
        createBoardViewController.delegate = self;
    }
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (void)customizeTableView {
    self.boardsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)showAlertForMessage:(NSString *)errorMessage {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alert show];
}

@end
