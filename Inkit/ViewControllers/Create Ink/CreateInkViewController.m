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
#import "EditTextViewController.h"
#import "DBUser+Management.h"
#import "DBInk+Management.h"
#import "DBBoard+Management.h"
#import "DBBodyPart+Management.h"
#import "DBTattooType+Management.h"
#import "DBImage+Management.h"
#import "DBArtist+Management.h"
#import "InkitConstants.h"
#import "DataManager.h"
#import "InkitTheme.h"
#import "InkitService.h"
#import "TextFieldTableViewCell.h"

static NSString * const CreateInkImageTableViewCellIdentifier = @"CreateInkImageTableViewCell";
static NSString * const CreateInkTableViewCellIdentifier = @"CreateInkInkTableViewCell";
static NSString * const TextFieldTableViewCellIdentifier = @"TextFieldTableViewCell";
static NSString * const InkDescriptionTableViewCellIdentifier = @"InkDescriptionTableViewCell";


#define kCreateInkCellHeight            44
#define kCreateInkTextFieldCellHeight   90
typedef enum
{
    kCreateInkImageIndex,
    kCreateInkDescriptionIndex,
    kCreateInkBoardIndex,
    kCreateInkBodyPartIndex,
    kCreateInkTattooTypeIndex,
    kCreateInkArtistIndex,
    //kCreateInkShopIndex,
    kCreateInkTotal,
} kCreateInkCells;

@interface CreateInkViewController () <SelectBoardDelegate, SelectLocalDelegate, SelectRemoteDelegate,UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate, EditTextViewDelegate, TextFieldTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *createInkTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createBarButtonItem;
@property (strong, nonatomic) UIImageView *inkImageView;
@property (strong, nonatomic) UITextView *selectedTextView;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) NSMutableDictionary* inkData;
@property (strong, nonatomic) UIAlertView* cancelAlertView;
@property (strong, nonatomic) UIAlertView* deleteAlertView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) DBUser* activeUser;

@end

@implementation CreateInkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Create Ink",nil);
    
    [self customizeNavigationBar];
    [self registerForKeyboardNotifications];
    [self hideActivityIndicator];
    self.activeUser = [DataManager sharedInstance].activeUser;
    
    if (self.isEditingInk) {
        self.inkImage = [self.editingInk.fullScreenImage getImage];
        self.inkData = [[self.editingInk toDictionary] mutableCopy];
        self.title = NSLocalizedString(@"Edit Ink",nil);
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(createInkButtonPressed:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
    } else if (self.isReInking) {
        self.inkImage = [self.editingInk.fullScreenImage getImage];
        self.inkData = [[self.editingInk toDictionary] mutableCopy];
        [self.inkData removeObjectForKey:kInkBoard];
        self.title = NSLocalizedString(@"ReInk",nil);
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Create", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(createInkButtonPressed:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
    } else {
        self.inkData = [[NSMutableDictionary alloc] init];
        self.title = NSLocalizedString(@"Create Ink",nil);
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Create", nil)
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(createInkButtonPressed:)];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:editButton];
    }
    [self customizeTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self.createInkTableView reloadData];
}

#pragma mark - TableView Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isEditingInk) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return kCreateInkTotal;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case kCreateInkImageIndex:
            {
                CreateInkImageTableViewCell* imageCell = [tableView dequeueReusableCellWithIdentifier:CreateInkImageTableViewCellIdentifier];
                [imageCell configureForImage:self.inkImage];
                cell = imageCell;
                break;
            }
            case kCreateInkDescriptionIndex:
            {
                TextFieldTableViewCell* textFieldCell = [tableView dequeueReusableCellWithIdentifier:TextFieldTableViewCellIdentifier];
                textFieldCell.placeholder = NSLocalizedString(@"Description",nil);;
                textFieldCell.text = self.inkData[kInkDescription];
                textFieldCell.delegate = self;
//
//                cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
//                if ([self.inkData objectForKey:kInkDescription]) {
//                    cell.textLabel.text = [self.inkData objectForKey:kInkDescription];
//                    cell.textLabel.textColor = [InkitTheme getColorForText];
//                } else {
//                    cell.textLabel.text = NSLocalizedString(@"Description",nil);
//                    cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
//                }
                cell = textFieldCell;
                break;
            }
            case kCreateInkBoardIndex:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
                    if ([self.inkData objectForKey:kInkBoard]) {
                        cell.textLabel.text = ((DBBoard *)[self.inkData objectForKey:kInkBoard]).boardTitle;
                        cell.textLabel.textColor = [InkitTheme getColorForText];
                    } else {
                        cell.textLabel.text = NSLocalizedString(@"Select Board",nil);
                        cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
                    }
                break;
            }
            case kCreateInkBodyPartIndex:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
                if ([self.inkData objectForKey:kInkBodyParts]) {
                    NSArray* bodyPartsArray = self.inkData[kInkBodyParts];
                    cell.textLabel.text = [DBBodyPart stringFromArray:bodyPartsArray];
                    cell.textLabel.textColor = [InkitTheme getColorForText];
                } else {
                    cell.textLabel.text = NSLocalizedString(@"Select Body Parts", nil);
                    cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
                }
                break;
            }
            case kCreateInkTattooTypeIndex:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
                if ([self.inkData objectForKey:kInkTattooTypes]) {
                    NSArray* tattooTypesArray = self.inkData[kInkTattooTypes];
                    cell.textLabel.text = [DBTattooType stringFromArray:tattooTypesArray];
                    cell.textLabel.textColor = [InkitTheme getColorForText];
                } else {
                    cell.textLabel.text = NSLocalizedString(@"Select Tattoo Types", nil);
                    cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
                }
                break;
            }
            case kCreateInkArtistIndex:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
                if ([self.inkData objectForKey:kInkArtist]) {
                    cell.textLabel.text = ((DBArtist *)[self.inkData objectForKey:kInkArtist]).fullName;
                    cell.textLabel.textColor = [InkitTheme getColorForText];
                } else {
                    cell.textLabel.text = NSLocalizedString(@"Select Artist", nil);
                    cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
                }
                break;
            }
//            case kCreateInkShopIndex:
//            {
//                cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
//                if (self.inkData[kInkShop]) {
//                   // cell.textLabel.text = [self.ink getArtistsAsString];
//                    cell.textLabel.textColor = [InkitTheme getColorForText];
//                } else {
//                    cell.textLabel.text = NSLocalizedString(@"Select Shop", nil);
//                    cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
//                }
//                break;
//            }
            default:
                break;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CreateInkTableViewCellIdentifier];
        cell.textLabel.textColor = [InkitTheme getColorForPlaceHolderText];
        cell.textLabel.text = @"Delete";
    }
    return cell;
}


#pragma mark - TableView Delegte Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if (indexPath.row == kCreateInkImageIndex) {
            CreateInkImageTableViewCell* imageCell = [tableView dequeueReusableCellWithIdentifier:CreateInkImageTableViewCellIdentifier];
            [imageCell configureForImage:self.inkImage];
            
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
            [imageCell setNeedsUpdateConstraints];
            [imageCell updateConstraintsIfNeeded];
            
            [imageCell setNeedsLayout];
            [imageCell layoutIfNeeded];
            
            CGFloat height = imageCell.cellHeight;
            height += 1;
            
            double maxHeight = tableView.frame.size.height - kCreateInkTotal*kCreateInkCellHeight;
            
            return MAX(maxHeight, height);
        }
//        else if (indexPath.row == kCreateInkDescriptionIndex){
//            InkDescriptionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:InkDescriptionTableViewCellIdentifier];
//            if ([self.inkData objectForKey:kInkDescription]) {
//                [cell configureForDescription:[self.inkData objectForKey:kInkDescription]];
//                // Make sure the constraints have been added to this cell, since it may have just been created from scratch
//                [cell setNeedsUpdateConstraints];
//                [cell updateConstraintsIfNeeded];
//                
//                [cell setNeedsLayout];
//                [cell layoutIfNeeded];
//                
//                // Get the actual height required for the cell
//                CGFloat height = cell.cellHeight;
//                height += 1;
//                
//                return MAX(height, kCreateInkCellHeight);
//            } else {
//                return kCreateInkCellHeight;
//            }
//        }
    else {
            return kCreateInkCellHeight;
        }
    } else {
        return kCreateInkCellHeight;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == kCreateInkDescriptionIndex) {
        return NO;
    } else {
        return YES;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
//            case kCreateInkDescriptionIndex:
//            {
//                [self performSegueWithIdentifier:@"EditTextSegue" sender:indexPath];
//                break;
//            }
            case kCreateInkBoardIndex:
            {
                [self performSegueWithIdentifier:@"SelectBoardSegue" sender:nil];
                break;
            }
            case kCreateInkBodyPartIndex:
            case kCreateInkTattooTypeIndex:
            {
                [self performSegueWithIdentifier:@"SelectLocalSegue" sender:indexPath];
                break;
            }
            case kCreateInkArtistIndex:
            //case kCreateInkShopIndex:
            {
                [self performSegueWithIdentifier:@"SelectRemoteSegue" sender:indexPath];
                break;
            }
            default:
                break;
        }
    } else {
        self.deleteAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to delete this ink", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil) ,nil];
        [self.deleteAlertView show];
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
        editTextViewController.textString = self.inkData[kInkDescription];
    } else if ([[segue destinationViewController] isKindOfClass:[SelectBoardTableViewController class]]) {
        SelectBoardTableViewController* selectBoardTableViewController = [segue destinationViewController];
        selectBoardTableViewController.selectedBoard = self.inkData[kInkBoard];
        selectBoardTableViewController.delegate = self;
    } else if ([[segue destinationViewController] isKindOfClass:[SelectLocalTableViewController class]]) {
        SelectLocalTableViewController* selectLocalTableViewController = [segue destinationViewController];
        selectLocalTableViewController.delegate = self;
        NSIndexPath* indexPath = (NSIndexPath* )sender;
        if (indexPath.row == kCreateInkBodyPartIndex) {
            selectLocalTableViewController.localsArray = [DBBodyPart getBodyPartsSorted];
            selectLocalTableViewController.selectedLocalsArray = [self.inkData[kInkBodyParts] mutableCopy];
            selectLocalTableViewController.title = NSLocalizedString(@"Select Body Parts",nil);
        } else if (indexPath.row == kCreateInkTattooTypeIndex) {
            selectLocalTableViewController.localsArray = [DBTattooType getTattooTypeSorted];
            selectLocalTableViewController.selectedLocalsArray = [self.inkData[kInkTattooTypes] mutableCopy];
            selectLocalTableViewController.title = NSLocalizedString(@"Select Tattoo Types",nil);
        }
    } else if ([[segue destinationViewController] isKindOfClass:[SelectRemoteViewController class]]) {
        SelectRemoteViewController* selectRemoteViewController = [segue destinationViewController];
        selectRemoteViewController.delegate = self;
        NSIndexPath* indexPath = (NSIndexPath* )sender;
        if (indexPath.row == kCreateInkArtistIndex) {
            selectRemoteViewController.type = kInkArtist;
            selectRemoteViewController.selectedRemote = self.inkData[kInkArtist];
            selectRemoteViewController.title = NSLocalizedString(@"Select Artist",nil);
        }
//        else if (indexPath.row == kCreateInkShopIndex) {
//            selectRemoteViewController.type = kInkShop;
//            selectRemoteViewController.selectedRemote = self.inkData[kInkShop];
//            selectRemoteViewController.title = NSLocalizedString(@"Select Shop",nil);
//        }
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
        if (self.isEditingInk) {
            [self showActivityIndicator];
            [InkitService updateInk:self.editingInk withDictionary:self.inkData withTarget:self completeAction:@selector(postInkCompleteAction:) completeError:@selector(postInkCompleteError:)];
        } else {
            [self showActivityIndicator];
            self.inkData[kInkImage] = self.inkImage;
            [InkitService createInk:self.inkData withTarget:self completeAction:@selector(postInkCompleteAction:) completeError:@selector(postInkCompleteError:)];
        }
    }
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    self.cancelAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"All data will be lost", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Accept", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil) ,nil];
    [self.cancelAlertView show];
}

- (void)postInkCompleteAction:(DBInk *)ink
{
    [self hideActivityIndicator];
    [self performSegueWithIdentifier:@"ViewInkSegue" sender:ink];
}

- (void)postInkCompleteError:(NSString *)error
{
    [self hideActivityIndicator];
    [self showAlertForMessage:error];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.cancelAlertView) {
        if (buttonIndex == 0) {
            if (self.editingInk) {
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } else if (alertView == self.deleteAlertView) {
        if (buttonIndex == 0) {
            [self.editingInk deleteInk];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark - EditTextViewController Delegate
- (void)didFinishEnteringText:(NSString *)text
{
    if (text.length > 0) {
    self.inkData[kInkDescription] = text;
    } else {
        [self.inkData removeObjectForKey:kInkDescription];
    }
    [self.createInkTableView reloadData];
}

#pragma mark - Select Board Delegate
- (void)didSelectBoard:(DBBoard *)board {
    self.inkData[kInkBoard] = board;
    [self.createInkTableView reloadData];
}

#pragma mark - Select Locals Delegate
- (void)didSelectLocals:(NSArray *)locals forType:(NSString *)type {
    if ([type isEqualToString:kInkBodyParts]) {
        if ([locals count]) {
            self.inkData[kInkBodyParts] = locals;
        } else {
            [self.inkData removeObjectForKey:kInkBodyParts];;
        }
    } else if ([type isEqualToString:kInkTattooTypes]) {
        if ([locals count]) {
            self.inkData[kInkTattooTypes] = locals;
        } else {
            [self.inkData removeObjectForKey:kInkTattooTypes];
        }
    }
}

#pragma mark - Select Remote Delegate
- (void)didSelectRemote:(NSManagedObject *)remote forType:(NSString *)type {
    if ([type isEqualToString:kInkArtist]) {
        self.inkData[kInkArtist] = remote;
    } else if ([type isEqualToString:kInkShop]) {
        self.inkData[kInkShop] = remote;
    }
}

#pragma mark - TextFieldTableViewCell Delegate
- (void)textFieldTableViewCell:(TextFieldTableViewCell *)cell didFinishEnteringText:(NSString *)text {
    if (text.length > 0) {
        self.inkData[kInkDescription] = text;
    } else {
        [self.inkData removeObjectForKey:kInkDescription];
    }
}

- (void)textFieldTableViewCellDidBeginEditing:(TextFieldTableViewCell *)cell {
    [self.createInkTableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (void)customizeTableView {
    [self.createInkTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:TextFieldTableViewCellIdentifier];
    self.createInkTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Helper Methods
- (BOOL)verifyCells {
    if(![self.inkData objectForKey:kInkDescription]) {
        [self showAlertForMessage:@"Complete Description"];
        return NO;
    } else if (![self.inkData objectForKey:kInkBoard]) {
        [self showAlertForMessage:@"Select Board"];
        return NO;
    }
    return YES;
}

- (void)showAlertForMessage:(NSString *)errorMessage {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator {
    self.createBarButtonItem.enabled = false;
    self.createInkTableView.userInteractionEnabled = false;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void) hideActivityIndicator {
    self.createBarButtonItem.enabled = true;
    self.createInkTableView.userInteractionEnabled = true;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
