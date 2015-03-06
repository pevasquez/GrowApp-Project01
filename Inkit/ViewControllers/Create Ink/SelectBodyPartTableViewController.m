//
//  SelectBodyPartTableViewController.m
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SelectBodyPartTableViewController.h"
#import "DBBodyPart+Management.h"
#import "InkitTheme.h"

static NSString * const BodyPartTableViewCellIdentifier = @"BodyPartTableViewCell";

@interface SelectBodyPartTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *bodyPartsTableView;
@property (strong, nonatomic) NSArray* bodyPartsArray;
@property (strong, nonatomic) NSMutableArray* filteredBodyPartsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *bodyPartsSearchBar;

@end

@implementation SelectBodyPartTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select Board",nil);
    [self customizeNavigationBar];
    [self customizeTableView];
    [self getBodyParts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideSearchBar];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self hideSearchBar];
}

#pragma mark - TableView Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:BodyPartTableViewCellIdentifier];
    DBBodyPart* bodyPart = self.filteredBodyPartsArray[indexPath.row];
    cell.textLabel.text = bodyPart.name;
    if ([self.editingInk.ofBodyParts containsObject:bodyPart]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.filteredBodyPartsArray count];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBBodyPart* bodyPart = self.filteredBodyPartsArray[indexPath.row];
    
    if ([self.editingInk.ofBodyParts containsObject:bodyPart]) {
        [self.editingInk removeOfBodyPartsObject:bodyPart];
    } else {
        [self.editingInk addOfBodyPartsObject:bodyPart];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Body Parts Methods
- (void)getBodyParts
{
    self.bodyPartsArray = [DBBodyPart getBodyPartsSortedInManagedObjectContext:self.editingInk.managedObjectContext];
    [self reloadFilteredBodyParts];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (void)customizeTableView
{
    self.bodyPartsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Search Bar Delegate Methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self.filteredBodyPartsArray removeAllObjects];
    // Filter the array using NSPredicate
    if (![text isEqualToString:@""]) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[c] %@",text];
        NSCompoundPredicate* predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1]];
        self.filteredBodyPartsArray = [NSMutableArray arrayWithArray:[self.bodyPartsArray filteredArrayUsingPredicate:predicate]];
    } else {
        [self reloadFilteredBodyParts];
        [self.bodyPartsSearchBar performSelector: @selector(resignFirstResponder)
                                       withObject: nil
                                       afterDelay: 0.3];
    }
    [self.bodyPartsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.bodyPartsSearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.bodyPartsSearchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.bodyPartsSearchBar resignFirstResponder];
}

-(void)hideSearchBar
{
    [self.bodyPartsTableView setContentOffset:CGPointMake(0,44) animated:NO];
}

- (void)reloadFilteredBodyParts
{
    self.filteredBodyPartsArray = [NSMutableArray arrayWithArray:self.bodyPartsArray];
}

@end
