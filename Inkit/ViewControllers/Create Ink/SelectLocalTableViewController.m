//
//  SelectBodyPartTableViewController.m
//  Inkit
//
//  Created by Cristian Pena on 5/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SelectLocalTableViewController.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"

static NSString * const LocalTableViewCellIdentifier = @"SelectLocalCell";

@interface SelectLocalTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *localsTableView;
@property (strong, nonatomic) NSMutableArray* filteredLocalsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *localsSearchBar;


@end

@implementation SelectLocalTableViewController

#pragma Life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeNavigationBar];
    [self customizeTableView];
    [self reloadFilteredLocals];
    if (!self.selectedLocalsArray) {
        self.selectedLocalsArray = [[NSMutableArray alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hideSearchBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideSearchBar];
}

#pragma mark - TableView Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LocalTableViewCellIdentifier];
    
    NSManagedObject* local = self.filteredLocalsArray[indexPath.row];
    if ([local isKindOfClass:[DBBodyPart class]]) {
        DBBodyPart* bodyPart = self.filteredLocalsArray[indexPath.row];
        cell.textLabel.text = bodyPart.name;
        if ([self.selectedLocalsArray containsObject:bodyPart]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if ([local isKindOfClass:[DBTattooType class]]) {
        DBTattooType* tattooType = self.filteredLocalsArray[indexPath.row];
        cell.textLabel.text = tattooType.name;
        if ([self.selectedLocalsArray containsObject:tattooType]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredLocalsArray count];
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject* local = self.filteredLocalsArray[indexPath.row];
    
    if ([local isKindOfClass:[DBBodyPart class]]) {
        DBBodyPart* bodyPart = (DBBodyPart *)local;
        if ([self.selectedLocalsArray containsObject:bodyPart]) {
            [self.selectedLocalsArray removeObject:bodyPart];
        } else {
            [self.selectedLocalsArray addObject:bodyPart];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if ([local isKindOfClass:[DBTattooType class]]) {
        DBTattooType* tattooType = (DBTattooType *)local;
        if ([self.selectedLocalsArray containsObject:tattooType]) {
            [self.selectedLocalsArray removeObject:tattooType];
        } else {
            [self.selectedLocalsArray addObject:tattooType];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark - Search Bar Delegate Methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    [self.filteredLocalsArray removeAllObjects];
    // Filter the array using NSPredicate
    if (![text isEqualToString:@""]) {
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[c] %@",text];
        NSCompoundPredicate* predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1]];
        self.filteredLocalsArray = [NSMutableArray arrayWithArray:[self.localsArray filteredArrayUsingPredicate:predicate]];
    } else {
        [self reloadFilteredLocals];
        [self.localsSearchBar performSelector: @selector(resignFirstResponder)
                                       withObject: nil
                                       afterDelay: 0.3];
    }
    [self.localsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.localsSearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.localsSearchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.localsSearchBar resignFirstResponder];
}

-(void)hideSearchBar {
    [self.localsTableView setContentOffset:CGPointMake(0,44) animated:NO];
}

- (void)reloadFilteredLocals {
    self.filteredLocalsArray = [NSMutableArray arrayWithArray:self.localsArray];
}

#pragma mark - Actions

- (IBAction)okButtonPressed:(UIBarButtonItem *)sender {
    
    NSManagedObject* local = [self.localsArray firstObject];

    if ([local isKindOfClass:[DBTattooType class]]) {
        [self.delegate didSelectLocals:self.selectedLocalsArray forType:kInkTattooTypes];
    } else {
        [self.delegate didSelectLocals:self.selectedLocalsArray forType:kInkBodyParts];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (void)customizeTableView {
    self.localsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

@end
