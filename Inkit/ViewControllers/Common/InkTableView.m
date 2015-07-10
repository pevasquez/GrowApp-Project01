//
//  InkTableView.m
//  Inkit
//
//  Created by Cristian Pena on 7/9/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InkTableView.h"
#import "ViewInkTableViewCell.h"
#import "DBInk+Management.h"

static NSString * const InkImageTableViewCellIdentifier = @"InkImageTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";
static NSString * const InkActionsTableViewCellIdentifier = @"InkActionsTableViewCell";
static NSString * const InkBoardTableViewCellIdentifier = @"InkBoardTableViewCell";
static NSString * const InkCommentTableViewCellIdentifier = @"InkCommentTableViewCell";
static NSString * const InkRemoteTableViewCellIdentifier = @"RemoteIdentifier";

typedef enum {
    kViewInkImage,
    //kInkRemote,
    kViewInkDescription,
    kViewInkActions,
    kViewInkBoard,
    kViewInkComment,
    kViewInkTotalCells
} kViewInkCells;

#define kInkActionsCellHeight   60
#define kInkCommentCellHeight   44

@interface InkTableView()

@end

@implementation InkTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureTableView];

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configureTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureTableView];
    }
    return self;
}

- (void)configureTableView {
    [self registerNib:[UINib nibWithNibName:@"InkImageTableViewCell" bundle:nil] forCellReuseIdentifier:InkImageTableViewCellIdentifier];
    [self registerNib:[UINib nibWithNibName:@"InkDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:InkDescriptionTableViewCellIdentifier];
    [self registerNib:[UINib nibWithNibName:@"InkActionsTableViewCell" bundle:nil] forCellReuseIdentifier:InkActionsTableViewCellIdentifier];
    [self registerNib:[UINib nibWithNibName:@"InkBoardTableViewCell" bundle:nil] forCellReuseIdentifier:InkBoardTableViewCellIdentifier];
    [self registerNib:[UINib nibWithNibName:@"InkCommentTableViewCell" bundle:nil] forCellReuseIdentifier:InkCommentTableViewCellIdentifier];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.ink) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kViewInkTotalCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = [self getInkCellIdentifierForIndexPath:indexPath];
    ViewInkTableViewCell* cell = [self dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.ink = self.ink;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kViewInkImage:
        {
            CGFloat aspectRatio = [self.ink getImageAspectRatio];
            if (aspectRatio > 0) {
                return tableView.bounds.size.width/aspectRatio;
            } else {
                return 300;
            }
            break;
        }
        case kViewInkDescription:
        {
            return 44.0;
            break;
        }
        case kViewInkActions:
        {
            return kInkActionsCellHeight;
            break;
        }
        case kViewInkComment:
        {
            return kInkCommentCellHeight;
            break;
        }
        default:
            return 44;
            break;
    }
}

#pragma mark - UITableView Delegate
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kViewInkComment || indexPath.row == kViewInkBoard || indexPath.row == kViewInkImage) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.inkTableViewDelegate inkTableView:self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Helper Methods
- (NSString *)getInkCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = nil;
    switch (indexPath.row) {
        case kViewInkImage:
        {
            cellIdentifier = InkImageTableViewCellIdentifier;
            break;
        }
        case kViewInkDescription:
        {
            cellIdentifier = InkDescriptionTableViewCellIdentifier;
            break;
        }
        case kViewInkActions:
        {
            cellIdentifier = InkActionsTableViewCellIdentifier;
            break;
        }
        case kViewInkBoard:
        {
            cellIdentifier = InkBoardTableViewCellIdentifier;
            break;
        }
        case kViewInkComment:
        {
            cellIdentifier = InkCommentTableViewCellIdentifier;
            break;
        }
            //        case kInkRemote:
            //        {
            //            cellIdentifier = InkRemoteTableViewCellIdentifier;
            //        }
        default:
            break;
    }
    return cellIdentifier;
}

@end
