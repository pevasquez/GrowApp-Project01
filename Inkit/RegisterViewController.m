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

@interface RegisterViewController () <UITextFieldDelegate, UserTypeDelegate>

@property (strong, nonatomic) IBOutlet UITextField *eMailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userType;
@property (strong, nonatomic) DBUser *user;

@end


@implementation RegisterViewController

- (IBAction)userTypeTextFieldClicked:(id)sender
{
    //[self performSegueWithIdentifier:@"UserType" sender:nil];
}

- (IBAction)registerButtonPressed:(id)sender {

    if ([self verifyTextFields]) {
        // Continue registration process
        self.user = [DBUser createNewUser];
        self.user.email = self.eMailTextField.text;
        self.user.password = self.passwordTextfield.text;
        self.user.firstName = self.firstNameTextField.text;
        self.user.lastName = self.lastNameTextField.text;
        
        [InkitService registerUser:self.user WithTarget:self completeAction:@selector(registerUserComplete) completeError:@selector(registerUserError:)];
    }
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
    // TODO: mostrar errores en caso de mail ya tomado, etc.
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



- (void)registerUserComplete {
    [self.delegate registrationCompleteForUser:self.user];

}
- (BOOL)verifyTextFields
{
    // TODO: Agregar chequeo password min 6 caracteres
    
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

#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}

@end
