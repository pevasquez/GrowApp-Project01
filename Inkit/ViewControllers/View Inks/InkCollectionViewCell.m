//
//  InkCollectionViewCell.m
//  Inkit
//
//  Created by Cristian Pena on 19/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkCollectionViewCell.h"
#import "DBInk+Management.h"
#import "ViewInkTableViewCell.h"

static NSString * const InkImageTableViewCellIdentifier = @"InkImageTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";
static NSString * const InkActionsTableViewCellIdentifier = @"InkActionsTableViewCell";
static NSString * const InkUserTableViewCellIdentifier = @"InkUserTableViewCell";


typedef NS_ENUM(NSInteger, InkCells) {
    kInkCellImage,
    kInkCellDescription,
    kInkCellActions,
    kInkCellUser,
    kInkCellTotalCells
} kInkCell;

#define kInkImageCellHeight     239
#define kInkActionsCellHeight   34
#define kInkUserCellHeight      40

@interface InkCollectionViewCell () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *inkTableView;
@end

@implementation InkCollectionViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.inkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.inkTableView reloadData];
}

- (double)getCellHeight
{
    [self.inkTableView reloadData];
    
    return self.inkTableView.contentSize.height;
}

- (void)prepareForReuse
{
    self.ink = nil;
}

#pragma mark UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = kInkCellTotalCells;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
    ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.ink = self.ink;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ink) {
        switch (indexPath.row) {
            case kInkCellImage:
            {
//                NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
//                ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//                cell.ink = self.ink;
//                
//                // Make sure the constraints have been added to this cell, since it may have just been created from scratch
//                [cell setNeedsUpdateConstraints];
//                [cell updateConstraintsIfNeeded];
//                
//                [cell setNeedsLayout];
//                [cell layoutIfNeeded];
//                
//                // Get the actual height required for the cell
//                CGFloat height = cell.cellHeight;
//                
//                // Add an extra point to the height to account for the cell separator, which is added between the bottom
//                // of the cell's contentView and the bottom of the table view cell.
//                height += 1;
//                
//                //return height;
#pragma mark - warning aca no anda
                
                return kInkImageCellHeight;
                break;
            }
            case kInkCellDescription:
            {
                NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
                ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                cell.ink = self.ink;
                
                // Make sure the constraints have been added to this cell, since it may have just been created from scratch
                [cell setNeedsUpdateConstraints];
                [cell updateConstraintsIfNeeded];
                
                [cell setNeedsLayout];
                [cell layoutIfNeeded];
                
                // Get the actual height required for the cell
                CGFloat height = cell.cellHeight;
                
                // Add an extra point to the height to account for the cell separator, which is added between the bottom
                // of the cell's contentView and the bottom of the table view cell.
                height += 1;
                
                return height;
                break;
            }
            case kInkCellActions:
            {
                return kInkActionsCellHeight;
                break;
            }
            case kInkCellUser:
            {
                return kInkUserCellHeight;
                break;
            }
            default:
                return 0;
                break;
        }
    }
    return kInkUserCellHeight;
}

- (NSString *)getInkCellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = nil;
    switch (indexPath.row) {
        case kInkCellImage:
        {
            cellIdentifier = InkImageTableViewCellIdentifier;
            break;
        }
        case kInkCellDescription:
        {
            cellIdentifier = InkDescriptionTableViewCellIdentifier;
            break;
        }
        case kInkCellActions:
        {
            cellIdentifier = InkActionsTableViewCellIdentifier;
            break;
        }
        case kInkCellUser:
        {
            cellIdentifier = InkUserTableViewCellIdentifier;
            break;
        }
        default:
            break;
    }
    return cellIdentifier;
}

@end
