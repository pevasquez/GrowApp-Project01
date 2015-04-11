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


@interface SelectRemoteTableViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *remoteTableView;
@property (strong, nonatomic) NSArray *tableData;

@end

@implementation SelectRemoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchForSearchString:@""];
}

- (void)getArtistError:(NSString *)stringError
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Artist not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)getArtistComplete:(NSArray *)artistsArray
{
    self.tableData = artistsArray;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectRemoteCell"];
    
    DBArtist* artist = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = artist.fullName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

- (void)searchForSearchString:(NSString *)string
{
    [InkitService getArtistsForSearchString:string withTarget:self completeAction:@selector(getArtistComplete:) completeError:@selector(getArtistError:)];
}

//#pragma mark - Search Bar Methods
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [self searchForSearchString:searchText];
//}

@end
