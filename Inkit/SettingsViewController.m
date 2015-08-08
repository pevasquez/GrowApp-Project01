//
//  Settings.m
//  Inkit
//
//  Created by Cristian Pena on 27/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SettingsViewController

- (id)init {
    self = [super init];
    return self;
}

static NSString *cellIdentifier;

#pragma marks - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideActivityIndicator];
    
    self.data = @[@"Log Out"];
    
    cellIdentifier = @"rowCell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    [self customizeTableView];
    [self customizeNavigationBar];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectSettings:self.data[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
    if (indexPath.row == 0) {
        [self showActivityIndicator];
        [InkitService logOutUser:[DataManager sharedInstance].activeUser withCompletion:^(id response, NSError *error) {
            [self hideActivityIndicator];
            if (error) {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:response message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            } else {
                AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate userLoggedOut];
            }
        }];
    }
}

- (void)customizeTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Activity Indicator Methods

- (void) showActivityIndicator {
    [GAProgressHUDHelper standarBlankHUD:self.view];
}

- (void) hideActivityIndicator {
    [GAProgressHUDHelper hideProgressHUDinView:self.view];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

@end
