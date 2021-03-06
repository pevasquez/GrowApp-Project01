//
//  UserTypeViewController.m
//  Inkit
//
//  Created by Cristian Pena on 25/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "UserTypeViewController.h"
#import "userTypeTableView.h"

NSString * const UserTypeUser = @"User";
NSString * const UserTypeArtist = @"Artist";
NSString * const UserTypeShop = @"Shop";

@interface UserTypeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *data;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserTypeViewController


-(id)init {
    self = [super init];
    return self;
}

static NSString *cellIdentifier;

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.data = @[UserTypeUser, UserTypeShop, UserTypeArtist];
    
    cellIdentifier = @"rowCell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self customizeTableView];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
        if ([self.selectedString isEqualToString:[self.data objectAtIndex:indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    
}

- (void)customizeTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectUserType:self.data[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
