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


typedef enum
{
    kInkImage,
    kInkDescription,
    kInkActions,
    kInkUser,
    kInkTotalCells
} kViewInkCells;

#define kInkImageCellHeight     239
#define kInkActionsCellHeight   34
#define kInkUserCellHeight      50

@interface InkCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UITableView *inkTableView;
@property (strong, nonatomic) DBInk* ink;
@end

@implementation InkCollectionViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.inkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)configureForInk:(DBInk *)ink
{
    self.ink = ink;
    [self.inkTableView reloadData];
}

- (double)getCellHeight
{
    [self.inkTableView reloadData];
    
    return self.inkTableView.contentSize.height;
}
#pragma mark UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = kInkTotalCells;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
    ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configureForInk:self.ink];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ink) {
        switch (indexPath.row) {
            case kInkImage:
            {
                NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
                ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                [cell configureForInk:self.ink];
                
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
                
                //return height;
#warning aca no anda
                return kInkImageCellHeight;
                break;
            }
            case kInkDescription:
            {
                NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
                ViewInkTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                [cell configureForInk:self.ink];
                
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
            case kInkActions:
            {
                return kInkActionsCellHeight;
                break;
            }
            case kInkUser:
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
        case kInkImage:
        {
            cellIdentifier = InkImageTableViewCellIdentifier;
            break;
        }
        case kInkDescription:
        {
            cellIdentifier = InkDescriptionTableViewCellIdentifier;
            break;
        }
        case kInkActions:
        {
            cellIdentifier = InkActionsTableViewCellIdentifier;
            break;
        }
        case kInkUser:
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
