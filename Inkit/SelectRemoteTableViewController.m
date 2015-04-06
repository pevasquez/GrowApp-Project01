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

@interface SelectRemoteTableViewController ()

@property (strong, nonatomic) IBOutlet UISearchBar *UIsearchBar;
@property (strong, nonatomic) IBOutlet UITableView *UItableViewCell;
@property (strong, nonatomic) NSArray *tableData;

@end

@implementation SelectRemoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [InkitService getArtistsForSearchString:@"Artist" withTarget:self completeAction:@selector(getArtistComplete:) completeError:@selector(getArtistError:)];
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
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    DBArtist* artist = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = artist.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}


@end
