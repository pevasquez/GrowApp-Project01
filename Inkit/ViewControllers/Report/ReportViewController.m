//
//  ReportViewController.m
//  Inkit
//
//  Created by Cristian Pena on 10/8/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import "ReportViewController.h"
#import "DBReportReason+Management.h"

@interface ReportViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *reportReasonsArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) DBReportReason *selectedReason;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.reportReasonsArray = [DBReportReason getReportReasonsSorted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reportReasonsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reportReasonCell"];
    
    DBReportReason *reportReason = self.reportReasonsArray[indexPath.row];
    cell.textLabel.text = reportReason.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.selectedIndexPath) {
        [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.selectedIndexPath = indexPath;
}

@end
