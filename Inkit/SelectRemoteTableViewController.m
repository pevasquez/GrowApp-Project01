//
//  RemoteTableViewController.m
//  Inkit
//
//  Created by Cristian Pena on 2/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SelectRemoteTableViewController.h"
#import "DBArtist+Management.h"
#import "DBShop+Management.h"

static NSString * const RemoteTableViewCellIdentifier = @"SelectRemoteCell";

@interface SelectRemoteViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *remoteTableView;
@property (strong, nonatomic) NSArray* filteredRemotesArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SelectRemoteViewController

#pragma mark - Life cycle methods 
- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchForSearchString:@""];
    [self hideActivityIndicator];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.filteredRemotesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RemoteTableViewCellIdentifier];
    
    NSManagedObject* remote = [self.filteredRemotesArray objectAtIndex:indexPath.row];
    
    if (self.selectedRemote == remote) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([remote isKindOfClass:[DBArtist class]]) {
        cell.textLabel.text = ((DBArtist *)remote).fullName;
    } else if ([remote isKindOfClass:[DBShop class]]) {
        cell.textLabel.text = ((DBShop *)remote).name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject* remote = self.filteredRemotesArray[indexPath.row];
    
    if ([self.selectedRemote isEqual:remote]) {
        self.selectedRemote = nil;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        self.selectedRemote = remote;
        [self.delegate didSelectRemote:remote forType:self.type];
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - Search Bar Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForSearchString:searchText];
}

- (void)searchForSearchString:(NSString *)string {
    [InkitService getRemotesForSearchString:string type:self.type withTarget:self completeAction:@selector(getRemotesComplete:) completeError:@selector(getRemotesError:)];
    [self showActivityIndicator];
}

- (void)getRemotesError:(NSString *)stringError {
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Term not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self hideActivityIndicator];
}

- (void)getRemotesComplete:(NSArray *)remotesArray {
    self.filteredRemotesArray = remotesArray;
    [self.remoteTableView reloadData];
    [self hideActivityIndicator];
}

#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void) hideActivityIndicator {
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

@end
