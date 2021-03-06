 //
//  LogInViewController.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "FacebookManager.h"
#import "GoogleManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RoundedCornerButton.h"
#import "FormViewController.h"
#import "Social/Social.h"
#import <Accounts/Accounts.h>


@interface LogInViewController () <RegisterDelegate, UITextFieldDelegate, FacebookManagerDelegate, GoogleManagerDelegate>

@property (strong, nonatomic) IBOutlet RoundedCornerButton *googleButton;
@property (strong, nonatomic) IBOutlet RoundedCornerButton *facebookButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet RoundedCornerButton *logInButton;
@property (strong, nonatomic) NSMutableDictionary* userDictionary;
@property (strong, nonatomic) IBOutlet UIView *scrollView;
@property (strong, nonatomic) UITextField* activeTextField;
@property (nonatomic) BOOL userIsEnteringEmail;

@end

@implementation LogInViewController

#pragma mark - Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideActivityIndicator];
    [self customizeNavigationBar];
    self.textFieldsArray = @[self.emailTextField, self.passwordTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
}

#pragma mark - Action Methods
- (IBAction)logInButtonPressed:(id)sender {
    [self login];
}

- (IBAction)registerButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
}

- (IBAction)facebookLoginPressed:(id)sender {
    [self showActivityIndicator];
    [FacebookManager sharedInstance].delegate = self;
    [[FacebookManager sharedInstance] internalLogInUser];
}

- (IBAction)GoogleSignInButton:(id)sender {
    [self showActivityIndicator];
    [GoogleManager sharedInstance].delegate = self;
    [[GoogleManager sharedInstance] logInUser];
}

- (IBAction)didTapScreen:(UITapGestureRecognizer *)sender {
    [self hideKeyboard];
}

#pragma mark - Mail Login
- (void)login {
    if([self verifyTextFields]) {
        NSDictionary* userDictionary = @{kUserEmail:self.emailTextField.text,kUserPassword:self.passwordTextField.text};
        [InkitService logInUserDictionary:userDictionary withCompletion:^(id response, NSError *error) {
            [self hideActivityIndicator];
            if (error) {
                UIAlertView *alert= [[UIAlertView alloc]initWithTitle:response message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            } else {
                [self.delegate logInDidFinishedLoading];
            }
        }];
        [self showActivityIndicator];
    }
}

#pragma mark - Social Login
- (void)socialLogin {
    [self showActivityIndicator];
    [InkitService logInSocialDictionary:self.userDictionary withCompletion:^(id response, NSError *error) {
        [self hideActivityIndicator];
        if (error) {
            if ([response isEqualToString:@"Bad credentials"]) {
                [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
            } else {
                [self showAlertForMessage:response];
            }
        } else {
            [self.delegate logInDidFinishedLoading];
        }
    }];
}

- (void)sdkLoginCancelledByUser {
    [self hideActivityIndicator];
}

- (void)sdkLoginError:(NSError *)error {
    [self hideActivityIndicator];
}

#pragma mark - FacebookManager Delegate Methods
- (void)onUserLoggedIn {
    
}

- (void)onUserLoggedOut {
    
}

- (void)onInternalLoginError:(NSError *)error {
    [[FacebookManager sharedInstance] sdkLogInUser];
}


// TODO: Revisar Parsing
- (void)onFacebookUserInfoRequestComplete:(NSDictionary <FBGraphUser> *) userInfo {
    self.userDictionary = [[NSMutableDictionary alloc] init];
    if([userInfo objectForKey:@"first_name"]) {
        self.userDictionary[kUserFirstName] = userInfo[@"first_name"];
    }
    if([userInfo objectForKey:@"last_name"]) {
        self.userDictionary[kUserLastName] = userInfo[@"last_name"];
    }
    if ([userInfo objectForKey:@"email"]) {
        self.userDictionary[kUserEmail] = userInfo[@"email"];
    }
    if ([userInfo objectForKey:@"id"]) {
        self.userDictionary[kUserExternalId] = userInfo[@"id"];
    } else {
        [self hideActivityIndicator];
        [self showAlertForMessage:[NSString stringWithFormat:@"We were unable to log you in with Facebook. %@", userInfo]];
        [[FacebookManager sharedInstance] sdkLogInUser];
        return;
    }
    self.userDictionary[kUserSocialNetworkId] = @"1";
    
    [self socialLogin];
}


- (void)onPermissionsDeclined:(NSArray *)declinedPermissions {
    NSLog(@"declined Permissions");
}

#pragma mark - Google+ Delegate

- (void)onGoogleUserInfoRequestComplete:(NSDictionary *)userInfo {
    self.userDictionary = [[NSMutableDictionary alloc] init];
    self.userDictionary[kUserFirstName] = userInfo[kUserFirstName];
    self.userDictionary[kUserLastName] = userInfo[kUserLastName];
    self.userDictionary[kUserEmail] = userInfo[kUserEmail];
    self.userDictionary[kUserExternalId] = userInfo[kUserExternalId];
    self.userDictionary[kUserSocialNetworkId] = @"3";
    [self socialLogin];
}

- (void)onGoogleUserLoggedIn {
    NSLog(@"Google User Logged In");
}

- (void)onGoogleUserLoggedOut {
    NSLog(@"Google User Logged Out");
}

#pragma mark - Register Delegate
- (void)registrationComplete {
    [self.delegate logInDidFinishedLoading];
    [self hideActivityIndicator];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RegisterSegue"]) {
        RegisterViewController* rvc = [segue destinationViewController];
        rvc.userDictionary = self.userDictionary;
        rvc.delegate = self;
    }
}

#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.activeTextField = nil;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [super textFieldShouldReturn:textField];
    if ([self isFormValid]){
        [self login];
    }
    return NO;
}

#pragma mark - Keyboard Notifications
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
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

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    } completion:nil];
}

#pragma mark - Helper Methods
- (BOOL)verifyTextFields {
    if([self.emailTextField.text isEqualToString:@""]) {
        [self showAlertForMessage:@"Complete Email"];
        return false;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        [self showAlertForMessage:@"Complete Password"];
        return false;
    }
    return true;
}

#pragma mark - Activity Indicator Methods
- (void)showActivityIndicator {
    [GAProgressHUDHelper loggingInProgressHUDinView:self.view];
    [self hideKeyboard];
    [self setTextFieldsEnabled:false];
    [self setButtonsEnabled:false];
}

- (void)hideActivityIndicator {
    [GAProgressHUDHelper hideHUDForView:self.view animated:true];
    [self setTextFieldsEnabled:true];
    [self setButtonsEnabled:true];
}

- (void)setButtonsEnabled:(BOOL)enabled {
    self.facebookButton.userInteractionEnabled = enabled;
    self.googleButton.userInteractionEnabled = enabled;
    self.logInButton.userInteractionEnabled = enabled;
}

#pragma mark - Appearence Methods
- (void)customizeNavigationBar {
    [InkitTheme setUpNavigationBarForViewController:self];
}

@end
