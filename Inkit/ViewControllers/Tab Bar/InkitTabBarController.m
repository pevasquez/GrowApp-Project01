//
//  InkitTabBarController.m
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkitTabBarController.h"
#import "InkitTheme.h"

@interface InkitTabBarController ()
@property (nonatomic) NSUInteger lastSelectedItem;
@end

typedef enum {
    kDashboard,
    kBoards,
    kInk,
    kBrowse,
    kAccount
} kTabBarItems;

@implementation InkitTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.tintColor = [InkitTheme getTintColor];
    self.selectedIndex = kDashboard;
    UITabBarItem* dashboard = [[self.tabBar items] objectAtIndex:kDashboard];
    [dashboard setTitle:NSLocalizedString(@"Dashboard", nil)];
    UITabBarItem* boards = [[self.tabBar items] objectAtIndex:kBoards];
    [boards setTitle:NSLocalizedString(@"My Boards", nil)];
    UITabBarItem* ink = [[self.tabBar items] objectAtIndex:kInk];
    [ink setTitle:NSLocalizedString(@"Ink", nil)];
    UITabBarItem* browse = [[self.tabBar items] objectAtIndex:kBrowse];
    [browse setTitle:NSLocalizedString(@"Browse", nil)];
    UITabBarItem* account = [[self.tabBar items] objectAtIndex:kAccount];
    [account setTitle:NSLocalizedString(@"Account", nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.lastSelectedItem = self.selectedIndex;
}

- (void)selectLastSelectedItem
{
    self.selectedIndex = self.lastSelectedItem;
}

- (void)selectDashboard
{
    self.selectedIndex = kDashboard;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
