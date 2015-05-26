//
//  RegisterViewController.m
//  Inkit
//
//  Created by Cristian Pena on 25/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserTypeViewController.h"
#import "InkitTheme.h"
#import "InkitService.h"
#import "InkitConstants.h"
#import "UIResponder+FirstResponder.h"
#import "GAProgressHUDHelper.h"

@interface RegisterViewController () <UITextFieldDelegate, UserTypeDelegate >
{
    NSString* name;
}
@property (strong, nonatomic) IBOutlet UITextField *eMailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userType;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIView *scrollView;
@property (strong, nonatomic) UITextField* activeTextField;

@end


@implementation RegisterViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideActivityIndicator];
    [self loadUserData];
    self.textFieldsArray = @[self.firstNameTextField, self.lastNameTextField,self.eMailTextField, self.passwordTextfield, self.confirmPasswordTextField];
}

- (void)loadUserData
{
    if (!self.userDictionary) {
        self.userDictionary = [[NSMutableDictionary alloc] init];
    }
    if ([self.userDictionary objectForKey:kUserEmail]) {
        self.eMailTextField.text = self.userDictionary[kUserEmail];
    }
    if ([self.userDictionary objectForKey:kUserFirstName]) {
        self.firstNameTextField.text = self.userDictionary[kUserFirstName];
    }
    if ([self.userDictionary objectForKey:kUserLastName]) {
        self.lastNameTextField.text = self.userDictionary[kUserLastName];
    }
    if ([self.userDictionary objectForKey:kUserPassword]) {
        self.passwordTextfield.text = self.userDictionary[kUserPassword];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Actions

- (IBAction)userTypeTextFieldClicked:(id)sender
{
    //[self performSegueWithIdentifier:@"UserType" sender:nil];
}

- (IBAction)registerButtonPressed:(id)sender
{
    [self hideKeyboard];
    [self registerUser];
}

- (IBAction)hideKeyboard:(UITapGestureRecognizer *)sender
{
    [self hideKeyboard];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Register User

- (void)registerUser {
    if ([self verifyTextFields]) {
        // Continue registration process
        self.userDictionary[kUserEmail] = self.eMailTextField.text;
        self.userDictionary[kUserFirstName] = self.firstNameTextField.text;
        self.userDictionary[kUserLastName] = self.lastNameTextField.text;
        self.userDictionary[kUserPassword] = self.passwordTextfield.text;
        
        [self showActivityIndicator];
        [self hideKeyboard];
        [InkitService registerUserDictionary:self.userDictionary WithTarget:self completeAction:@selector(registerUserComplete) completeError:@selector(registerUserError:)];
    }
}


- (void)registerUserError:(NSString *)errorMessage {
    [self hideActivityIndicator];
    // TODO: mostrar errores en caso de mail ya tomado, etc.
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (void)registerUserComplete {
    [self hideActivityIndicator];
    [self.delegate registrationComplete];

}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.userType) {
        [self performSegueWithIdentifier:@"UserType" sender:nil];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    self.activeTextField = nil;
}

#pragma mark - Verify Text Fields

- (BOOL)verifyTextFields
{
    //verificar campos para que esté completo.
    
    if(![self.passwordTextfield.text isEqualToString:self.confirmPasswordTextField.text]) {
        
        [self showAlertForMessage:@"Password don't match"];
        
    } else if ([self.eMailTextField.text isEqualToString:@""]) {
        
        [self showAlertForMessage:@"Complete Email"];
        
    } else if ([self.firstNameTextField.text isEqualToString:@""]) {
        
        [self showAlertForMessage:@"Complete Email"];
        
    } else if ([self.lastNameTextField.text isEqualToString:@""]) {
        
        [self showAlertForMessage:@"Complete Email"];
        
    } else if ([self.passwordTextfield.text isEqualToString:@""]) {
        
        [self showAlertForMessage:@"Complete Password"];
        
    } else if ([self.userType.text isEqualToString:@""]) {
        
        [self showAlertForMessage:@"Complete User Type"];

        return NO;
    }
    
    return YES;
}

// usertype delegate
- (void)didSelectUserType:(NSString *)userType
{
    self.userType.text = userType;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hideKeyboard];
    if ([[segue destinationViewController] isKindOfClass:[UserTypeViewController class]]) {
        UserTypeViewController* utvc = [segue destinationViewController];
        utvc.delegate = self;
        utvc.selectedString = self.userType.text;
    }
}


#pragma mark - Activity Indicator Methods

- (void) showActivityIndicator
{
    [GAProgressHUDHelper registeringProgressHUDinView:self.view];
    [self disableTextFields];
    [self hideKeyboard];
//    self.eMailTextField.userInteractionEnabled = NO;
//    self.passwordTextfield.userInteractionEnabled = NO;
//    self.confirmPasswordTextField.userInteractionEnabled = NO;
//    self.firstNameTextField.userInteractionEnabled = NO;
//    self.lastNameTextField.userInteractionEnabled = NO;
//    self.userType.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    [self.eMailTextField resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.userType resignFirstResponder];
}

- (void) hideActivityIndicator
{
    [GAProgressHUDHelper hideProgressHUDinView:self.view];
//    self.eMailTextField.userInteractionEnabled = YES;
//    self.passwordTextfield.userInteractionEnabled = YES;
//    self.confirmPasswordTextField.userInteractionEnabled = YES;
//    self.firstNameTextField.userInteractionEnabled = YES;
//    self.lastNameTextField.userInteractionEnabled = YES;
//    self.userType.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;

    [self.activityIndicatorView stopAnimating];
}



#pragma mark - Keyboard Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGPoint kbOrigin = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    
    CGPoint tfOrigin =[self.view convertPoint:self.activeTextField.frame.origin fromView:self.scrollView];
    CGPoint tfEnd = CGPointMake(tfOrigin.x, tfOrigin.y + self.activeTextField.frame.size.height);
    
    if (tfEnd.y > kbOrigin.y) {
        CGFloat distanceToScroll = tfEnd.y - kbOrigin.y + 40;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.scrollView.frame = CGRectMake(0, - distanceToScroll, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        } completion:nil];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    } completion:nil];
}


#pragma mark - Appearence Methods

- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [super textFieldShouldReturn:textField];
    if ([self isFormValid]){
        [self registerUser];
    }
    return NO;
}


#pragma mark - Helper Methods

//- (void)showAlertForMessage:(NSString *)errorMessage
//{
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles: nil];
//    [alert show];
//}
@end
