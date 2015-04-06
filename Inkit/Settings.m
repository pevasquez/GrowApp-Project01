//
//  Settings.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 27/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "Settings.h"
#import "InkitService.h"
#import "InkitDataUtil.h"
#import "AppDelegate.h"

@interface Settings () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation Settings

-(id)init
{
    self = [super init];
    return self;
}

static NSString *cellIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideActivityIndicator];
    
    self.data = @[@"Log Out",
                  @"Etc",
                  @"Etc",
                  @"Etc",
                  @"Etc"];
    
    cellIdentifier = @"rowCell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];

    [self customizeTableView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

//
- (void)customizeTableView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    

}


- (void)logOutUserComplete
{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate userLoggedOut];
    [self hideActivityIndicator];
}

- (void)logOutUserError:(NSString *)errorMessage
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self hideActivityIndicator];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didSelectSettings:self.data[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
    
    if (indexPath.row == 0)
    {
        [self showActivityIndicator];
        [InkitService logOutUser:[InkitDataUtil sharedInstance].activeUser WithTarget:self completeAction:@selector(logOutUserComplete) completeError:@selector(logOutUserError:)];
    }
}


#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator
{
    self.activityIndicatorView.hidden = NO;
    
    [self.activityIndicatorView startAnimating];
}

- (void) hideActivityIndicator
{
    self.activityIndicatorView.hidden = YES;
    
    [self.activityIndicatorView stopAnimating];
}

@end
