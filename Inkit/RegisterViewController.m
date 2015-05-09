//
//  RegisterViewController.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 25/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserTypeViewController.h"
#import "InkitTheme.h"
#import "InkitService.h"
#import "InkitConstants.h"

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
@property (strong, nonatomic) DBUser *user;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end


@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideActivityIndicator];
    [self loadUserData];
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

- (IBAction)userTypeTextFieldClicked:(id)sender
{
    //[self performSegueWithIdentifier:@"UserType" sender:nil];
}

- (void)registerUser {
    if ([self verifyTextFields]) {
        // Continue registration process
        self.userDictionary[kUserEmail] = self.eMailTextField.text;
        self.userDictionary[kUserFirstName] = self.firstNameTextField.text;
        self.userDictionary[kUserLastName] = self.lastNameTextField.text;
        self.userDictionary[kUserPassword] = self.passwordTextfield.text;
        
        [self showActivityIndicator];
        [InkitService registerUserDictionary:self.userDictionary WithTarget:self completeAction:@selector(registerUserComplete) completeError:@selector(registerUserError:)];
    }
}

- (IBAction)registerButtonPressed:(id)sender {

    [self registerUser];
}

- (void)registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: self.eMailTextField.text forKey:@"E-mail"];
    [defaults setObject:self.passwordTextfield.text forKey:@"Password"];
    [defaults setBool:YES forKey:@"Registered"];
    
    UIAlertView *success= [[UIAlertView alloc]initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [success show];
}

- (void)registerUserError:(NSString *)errorMessage {
    [self hideActivityIndicator];
    // TODO: mostrar errores en caso de mail ya tomado, etc.
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



- (void)registerUserComplete {
    [self hideActivityIndicator];
    [self.delegate registrationCompleteForUser:self.user];

}
- (BOOL)verifyTextFields
{
    //verificar campos para que esté completo.
    
    if(![self.passwordTextfield.text isEqualToString:self.confirmPasswordTextField.text]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Password don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        return NO;
        
    } else if ([self.eMailTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    } else if ([self.firstNameTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    } else if ([self.lastNameTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];


    } else if ([self.passwordTextfield.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    } else if ([self.userType.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete User Type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];

        return NO;
    }
    
    return YES;
}

// Textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.userType) {
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"UserType" sender:nil];
    }
}

// usertype delegate
- (void)didSelectUserType:(NSString *)userType
{
    self.userType.text = userType;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[UserTypeViewController class]]) {
        UserTypeViewController* utvc = [segue destinationViewController];
        utvc.delegate = self;
        utvc.selectedString = self.userType.text;
    }
}

//activity indicator
#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator
{
    self.eMailTextField.userInteractionEnabled = NO;
    self.passwordTextfield.userInteractionEnabled = NO;
    self.confirmPasswordTextField.userInteractionEnabled = NO;
    self.firstNameTextField.userInteractionEnabled = NO;
    self.lastNameTextField.userInteractionEnabled = NO;
    self.userType.userInteractionEnabled = NO;
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
    self.eMailTextField.userInteractionEnabled = YES;
    self.passwordTextfield.userInteractionEnabled = YES;
    self.confirmPasswordTextField.userInteractionEnabled = YES;
    self.firstNameTextField.userInteractionEnabled = YES;
    self.lastNameTextField.userInteractionEnabled = YES;
    self.userType.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;

    [self.activityIndicatorView stopAnimating];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //int numberOfChracters = 0;
    //bool lowerCaseLetter = false, upperCaseLetter = false, digit = false, specialCharacter = 0;
    if (textField == self.passwordTextfield) {
        if ([textField.text length] < 6) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hey!" message:@"Please Enter at least 6 characters for the password" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    }else if (textField == self.lastNameTextField){
        [self.eMailTextField becomeFirstResponder];
    }else if (textField == self.eMailTextField){
        [self.passwordTextfield becomeFirstResponder];
    }else if (textField == self.passwordTextfield){
        [self.confirmPasswordTextField becomeFirstResponder];
    }else if (textField == self.confirmPasswordTextField){
        [self.userType becomeFirstResponder];
    }else if (textField == self.userType){
        [self registerUser];
    }
    return NO;
}
@end
