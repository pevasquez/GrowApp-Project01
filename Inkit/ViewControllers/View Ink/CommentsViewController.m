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
#import "DBUser+Management.h"
#import "DataManager.h"

static NSString * const CommentsTableViewCellIdentifier = @"CommentsTableViewCell";

@interface CommentsViewController ()
@property (weak, nonatomic) IBOutlet CommentsTableView *commentsTableView;
@property (strong, nonatomic) NSArray* commentsArray;
@property (strong, nonatomic) DBUser* activeUser;
@end
@implementation CommentsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commentsTableView.commentsDelegate = self;
    [self updateCommentsTableView];
    self.commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.commentsTableView becomeFirstResponder];
    self.activeUser = [DataManager sharedInstance].activeUser;
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
    cell.comment =comment;
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
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}

#pragma mark - CommentsTableViewDelegate
- (void)commentsTableView:(CommentsTableView *)commentsTableView didEnterNewComment:(NSString *)comment
{
    [self.ink addCommentWithText:comment forUser:self.activeUser];
    [self updateCommentsTableView];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:0.5];
}
- (void)dismissViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateCommentsTableView
{
    self.commentsArray = self.ink.comments.allObjects;
    [self.commentsTableView reloadData];
}
@end
