//
//  CommentsViewController.m
//  Inkit
//
//  Created by Cristian Pena on 7/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentsTableViewCell.h"
#import "CommentsTableView.h"
#import "DataManager.h"
#import "InkitService.h"
#import "GAProgressHUDHelper.h"

static NSString * const CommentsTableViewCellIdentifier = @"CommentsTableViewCell";

@interface CommentsViewController ()
@property (weak, nonatomic) IBOutlet CommentsTableView *commentsTableView;
@property (strong, nonatomic) NSArray* commentsArray;
@property (strong, nonatomic) DBUser* activeUser;
@end
@implementation CommentsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCommentsTableView];
    [self registerForKeyboardNotifications];
    self.activeUser = [DataManager sharedInstance].activeUser;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getComments];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.commentsTableView becomeFirstResponder];
    [self.commentsTableView showKeyboard];
}

#pragma mark - TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.commentsArray count]) {
        self.commentsTableView.backgroundView = nil;
        return 1;
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Be the first to comment";
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.commentsTableView.backgroundView = messageLabel;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CommentsTableViewCellIdentifier];
    DBComment* comment = self.commentsArray[indexPath.row];
    cell.comment = comment;
    return cell;
}

#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CommentsTableViewCellIdentifier];
    cell.comment = self.commentsArray[indexPath.row];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = cell.cellHeight;
    
    height += 1;
    
    return height;
}

#pragma mark - CommentsTableViewDelegate
- (void)commentsTableView:(CommentsTableView *)commentsTableView didEnterNewComment:(NSString *)comment
{
    [GAProgressHUDHelper postCommentHUDinView:self.view];
    [InkitService postComment:comment toInk:self.ink completion:^(id response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [GAProgressHUDHelper hideProgressHUDinView:self.view];
            if (error == nil) {
                [self getComments];
//                [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:0.5];
            } else {
                
            }
        });
    }];
}

- (void)getComments {
    [InkitService getCommentsForInk:self.ink completion:^(id response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                [self updateCommentsTableView];
            } else {
                // show alert
            }
        });
    }];
}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    UIEdgeInsets insets = UIEdgeInsetsMake(self.commentsTableView.contentInset.top, 0, kbSize.height, 0);
    self.commentsTableView.contentInset = insets;
}

- (void)setUpCommentsTableView {
    self.commentsTableView.commentsDelegate = self;
    self.commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)updateCommentsTableView {
    self.commentsArray = [self.ink getCommentsSorted];
    [self.commentsTableView reloadData];
}
@end
