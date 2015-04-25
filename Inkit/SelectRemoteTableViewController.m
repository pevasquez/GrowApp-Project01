//
//  RemoteTableViewController.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 2/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SelectRemoteTableViewController.h"
#import "DBArtist+Management.h"
#import "InkitService.h"
#import "InkService.h"
#import "DBShop+Management.h"
#import "InkitTheme.h"

static NSString * const RemoteTableViewCellIdentifier = @"SelectRemoteCell";

@interface SelectRemoteViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *remoteTableView;
@property (strong, nonatomic) NSArray* filteredRemotesArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SelectRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchForSearchString:@""];
    [self hideActivityIndicator];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject* remote = self.filteredRemotesArray[indexPath.row];
    
    if ([remote isKindOfClass:[DBArtist class]]) {
        DBArtist* artist = (DBArtist *)remote;
        if ([self.editingInk.artist isEqual:artist]) {
            self.editingInk.artist = nil;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            self.editingInk.artist = artist;
            [tableView reloadData];
        }
    } else if ([remote isKindOfClass:[DBShop class]]) {
        DBShop* shop = (DBShop *)remote;
        if ([self.editingInk.shop isEqual:shop]) {
            self.editingInk.shop = nil;
        } else {
            self.editingInk.shop = shop;
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.filteredRemotesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RemoteTableViewCellIdentifier];
    
    DBArtist* artist = [self.filteredRemotesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = artist.fullName;
    if (self.editingInk.artist == artist) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - Search Bar Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchForSearchString:searchText];
}

- (void)searchForSearchString:(NSString *)string
{
    [InkitService getArtistsForSearchString:string withTarget:self completeAction:@selector(getArtistComplete:) completeError:@selector(getArtistError:)];
    [self showActivityIndicator];
}

- (void)getArtistError:(NSString *)stringError
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Artist not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self hideActivityIndicator];
}

- (void)getArtistComplete:(NSArray *)artistsArray
{
    self.filteredRemotesArray = artistsArray;
    [self.remoteTableView reloadData];
    [self hideActivityIndicator];
}

#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void) hideActivityIndicator
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

@end
