//
//  CreateInkViewController.m
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CreateInkViewController.h"
#import "CreateInkImageTableViewCell.h"
#import "SelectBoardTableViewController.h"
#import "SelectLocalTableViewController.h"
#import "SelectRemoteTableViewController.h"
#import "InkDescriptionTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "ViewInkViewController.h"
#import "DBInk+Management.h"
#import "DBBoard+Management.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBImage+Management.h"
#import "AppDelegate.h"
#import "InkitDataUtil.h"
#import "InkitTheme.h"
#import "InkitService.h"

static NSString * const CreateInkImageTableViewCellIdentifier = @"CreateInkImageTableViewCell";
static NSString * const CreateInkTableViewCellIdentifier = @"CreateInkInkTableViewCell";
static NSString * const TextFieldTableViewCellIdentifier = @"TextFieldTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";

#define kCreateInkCellHeight            44
#define kCreateInkTextFieldCellHeight   90
typedef enum
{
    kInkImage,
    kInkDescription,
    kInkBoard,
    //kInkCategory,
    kInkBodyPart,
    kInkTattooType,
    kInkArtist,
    kInkShop,
    kCreateInkTotal,
} kCreateInkCells;

@interface CreateInkViewController () <SelectBoardDelegate>
@property (weak, nonatomic) IBOutlet UITableView *createInkTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (strong, nonatomic) UIImageView *inkImageView;
@property (strong, nonatomic) UITextView *selectedTextView;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) DBInk* ink;

@end

@implementation CreateInkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Create Ink",nil);
    
    [self customizeNavigationBar];
    [self registerForKeyboardNotifications];
    self.inkImageView.image = self.inkImage;
    if (!self.activeUser) {
        self.activeUser = [InkitDataUtil sharedInstance].activeUser;
    }
    if (!self.editingInk) {
        self.ink = [DBInk createNewInk];
        DBImage* image = [DBImage fromUIImage:self.inkImage];
        [image addInkObject:self.ink];
        self.title = NSLocalizedString(@"Create Ink",nil);
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Create", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(createInkButtonPressed:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
    } else {
        self.ink = [DBInk inkWithInk:self.editingInk];
        self.title = NSLocalizedString(@"Edit Ink",nil);
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(createInkButtonPressed:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
    }
    [self customizeTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.createInkTableView reloadData];
}

#pragma mark - TableView Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kCreateInkTotal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.row) {
        case kInkImage:
        {
            CreateInkImageTableViewCell* imageCell = [tableView dequeueReusableCellWithIdentifier:CreateInkImageTableViewCellIdentifier];
            [imageCell configureForImage:[self.ink.image getImage]];
            cell = imageCell;
            break;
        }
        case kInkDescription:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
            if ([self.ink.inkDescription isEqualToString:@""]) {
                cell.textLabel.text = NSLocalizedString(@"Description",nil);
                cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
            } else {
                cell.textLabel.text = self.ink.inkDescription;
                cell.textLabel.textColor = [InkitTheme getColorForText];
            }
            break;
        }
        case kInkBoard:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
                if (!self.ink.inBoard) {
                    cell.textLabel.text = NSLocalizedString(@"Select Board",nil);
                    cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
                } else {
                    cell.textLabel.text = self.ink.inBoard.boardTitle;
                    cell.textLabel.textColor = [InkitTheme getColorForText];
                }
            break;
        }
        case kInkBodyPart:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
            if ([self.ink.ofBodyParts count]) {
                cell.textLabel.text = [self.ink getBodyPartsAsString];
                cell.textLabel.textColor = [InkitTheme getColorForText];
            } else {
                cell.textLabel.text = NSLocalizedString(@"Select Body Parts", nil);
                cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
            }
            break;
        }
        case kInkTattooType:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
            if ([self.ink.ofTattooTypes count]) {
                cell.textLabel.text = [self.ink getTattooTypesAsString];
                cell.textLabel.textColor = [InkitTheme getColorForText];
            } else {
                cell.textLabel.text = NSLocalizedString(@"Select Tattoo Types", nil);
                cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
            }
            break;
        }
        case kInkArtist:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
            if (self.ink.ofArtist) {
                cell.textLabel.text = [self.ink getArtistAsString];
                cell.textLabel.textColor = [InkitTheme getColorForText];
            } else {
                cell.textLabel.text = NSLocalizedString(@"Select Artist", nil);
                cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
            }
            break;
        }

        case kInkShop:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
            if (self.ink.ofShop) {
                cell.textLabel.text = [self.ink getArtistAsString];
                cell.textLabel.textColor = [InkitTheme getColorForText];
            } else {
                cell.textLabel.text = NSLocalizedString(@"Select Shop", nil);
                cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
            }
            break;
        }


        default:
            break;
    }
    return cell;
}

- (BOOL)verifyCells
{
    if([self.ink.inkDescription isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    } else if ([self.ink.inkDescription isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    } else if (!self.ink.inBoard) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Select Board" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else if ([self.ink.ofBodyParts count]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Select Body Part" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else if ([self.ink.ofTattooTypes count]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Select Tattoo Type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else if (self.ink.ofArtist) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Select Artist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }else if (self.ink.ofShop) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Select Shop" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    
    }
    return YES;
}

#pragma mark - TableView Delegte Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kInkImage) {
        CreateInkImageTableViewCell* imageCell = [tableView dequeueReusableCellWithIdentifier:CreateInkImageTableViewCellIdentifier];
        [imageCell configureForImage:[self.ink.image getImage]];
        
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        [imageCell setNeedsUpdateConstraints];
        [imageCell updateConstraintsIfNeeded];
        
        [imageCell setNeedsLayout];
        [imageCell layoutIfNeeded];

        CGFloat height = imageCell.cellHeight;
        height += 1;
        
        double maxHeight = tableView.frame.size.height - kCreateInkTotal*kCreateInkCellHeight;

        return MIN(maxHeight, height);
    } else if (indexPath.row == kInkDescription){
        InkDescriptionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:InkDescriptionTableViewCellIdentifier];
        [cell configureForDescription:self.ink.inkDescription];
        
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        // Get the actual height required for the cell
        CGFloat height = cell.cellHeight;
        height += 1;
        
        return MAX(height, kCreateInkCellHeight);
    } else {
        return kCreateInkCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case kInkDescription:
        {
            [self performSegueWithIdentifier:@"EditTextSegue" sender:indexPath];
            break;
        }
        case kInkBoard:
        {
            [self performSegueWithIdentifier:@"SelectBoardSegue" sender:nil];
            break;
        }
        case kInkBodyPart:
        case kInkTattooType:
        {
            [self performSegueWithIdentifier:@"SelectLocalSegue" sender:indexPath];
            break;
        }
        case kInkArtist:
        case kInkShop:
        {
            [self performSegueWithIdentifier:@"SelectRemoteSegue" sender:indexPath];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[ViewInkViewController class]]) {
        ViewInkViewController* viewInkViewController = [segue destinationViewController];
        viewInkViewController.ink = (DBInk *)sender;
    } else if ([[segue destinationViewController] isKindOfClass:[EditTextViewController class]]) {
        EditTextViewController* editTextViewController = [segue destinationViewController];
        editTextViewController.delegate = self;
        editTextViewController.textString = self.ink.inkDescription;
    } else if ([[segue destinationViewController] isKindOfClass:[SelectBoardTableViewController class]]) {
        SelectBoardTableViewController* selectBoardTableViewController = [segue destinationViewController];
        selectBoardTableViewController.activeUser = self.activeUser;
        selectBoardTableViewController.delegate = self;
    } else if ([[segue destinationViewController] isKindOfClass:[SelectLocalTableViewController class]]) {
        SelectLocalTableViewController* selectLocalTableViewController = [segue destinationViewController];
        selectLocalTableViewController.editingInk = self.ink;
        NSIndexPath* indexPath = (NSIndexPath* )sender;
        if (indexPath.row == kInkBodyPart) {
            selectLocalTableViewController.localsArray = [DBBodyPart getBodyPartsSortedInManagedObjectContext:self.activeUser.managedObjectContext];
            selectLocalTableViewController.title = NSLocalizedString(@"Select Body Parts",nil);
        } else if (indexPath.row == kInkTattooType) {
            selectLocalTableViewController.localsArray = [DBTattooType getTattooTypeSortedInManagedObjectContext:self.activeUser.managedObjectContext];
            selectLocalTableViewController.title = NSLocalizedString(@"Select Tattoo Types",nil);
        }
    } else if ([[segue destinationViewController] isKindOfClass:[SelectRemoteTableViewController class]]) {
        SelectRemoteTableViewController* selectRemoteTableViewController = [segue destinationViewController];
        selectRemoteTableViewController.editingInk = self.ink;
        NSIndexPath* indexPath = (NSIndexPath* )sender;
        if (indexPath.row == kInkArtist) {
            selectRemoteTableViewController.title = NSLocalizedString(@"Select Artist",nil);
        } else if (indexPath.row == kInkShop) {
            selectRemoteTableViewController.title = NSLocalizedString(@"Select Shop",nil);
        }
    }
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    NSIndexPath* oldIndexPath = self.selectedIndexPath;
    self.selectedIndexPath = nil;
    [self.view endEditing:YES];
    [self.selectedTextView resignFirstResponder];
    self.selectedTextView = nil;
    [self.createInkTableView reloadRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)createInkButtonPressed:(UIBarButtonItem *)sender
{
    if ([self verifyCells]) {
        [self.ink postWithTarget:self completeAction:@selector(postInkCompleteAction:) completeError:@selector(postInkCompleteError:)];
    }
}



- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    //[self.ink delete];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"All data will be lost", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Accept", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil) ,nil];
    [alertView show];
}

- (void)postInkCompleteAction:(DBInk *)ink
{
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:ink];
}

- (void)postInkCompleteError:(NSString *)error
{
    
}
#pragma mark - Keyboard Notifications
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.createInkTableView.frame= CGRectMake(self.createInkTableView.frame.origin.x, self.createInkTableView.frame.origin.y, self.createInkTableView.frame.size.width, self.createInkTableView.frame.size.height - kbSize.height);
    [self.createInkTableView scrollToRowAtIndexPath:self.selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.createInkTableView.frame= self.view.frame;
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (self.editingInk) {
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - EditTextViewController Delegate
- (void)didFinishEnteringText:(NSString *)text
{
    self.ink.inkDescription = text;
    [self.createInkTableView reloadData];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (void)customizeTableView
{
    self.createInkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Select Board Delegate
- (void)boardSelected:(DBBoard *)board
{
    self.ink.inBoard = board;
    [self.createInkTableView reloadData];
}

@end
