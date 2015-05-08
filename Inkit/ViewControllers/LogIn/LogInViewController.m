//
//  LogInViewController.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "InkitService.h"
#import "InkitTheme.h"
#import "InkitConstants.h"
#import "FacebookManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>



@interface LogInViewController () <RegisterDelegate, UITextFieldDelegate, FacebookManagerDelegate, GPPSignInDelegate>

@property (strong, nonatomic) IBOutlet UIButton *googleSignInButton;

@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UITextField *logInEmailTextField;

@property (strong, nonatomic) IBOutlet UITextField *logInPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) NSMutableDictionary* userDictionary;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideActivityIndicator];
    
    [self customizeNavigationBar];
    
    [GPPSignIn sharedInstance].delegate = self;
    [[GPPSignIn sharedInstance]trySilentAuthentication];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInUserComplete
{
    [self.delegate logInDidFinishedLoading];
    [self hideActivityIndicator];
}

- (void)logInUserError:(NSString *)errorMessage
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [self hideActivityIndicator];
}

- (IBAction)registerButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
}

- (void)login {
    if([self verifyTextFields])
    {
        NSDictionary* userDictionary = @{kUserEmail:self.logInEmailTextField.text,kUserPassword:self.logInPasswordTextField.text};
        [InkitService logInUserDictionary:userDictionary withTarget:self completeAction:@selector(logInUserComplete) completeError:@selector(logInUserError:)];
        [self showActivityIndicator];
    }
}

- (IBAction)logInButtonPressed:(id)sender {
    
    [self login];
}

- (BOOL)verifyTextFields
{
    if([self.logInEmailTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    } else if ([self.logInPasswordTextField.text isEqualToString:@""]) {
        
        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Message" message:@"Complete Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (IBAction)facebookLoginPressed:(id)sender {
    // If the session state is any of the two "open" states when the button is clicked
//    if (FBSession.activeSession.state == FBSessionStateOpen
//        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
//        [FBSession.activeSession closeAndClearTokenInformation];
//    }
    [FacebookManager sharedInstance].delegate = self;
    [[FacebookManager sharedInstance] logInUser];

}


#pragma mark - Appearence Methods
- (void)customizeNavigationBar
{
    [InkitTheme setUpNavigationBarForViewController:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RegisterSegue"]) {
        RegisterViewController* rvc = [segue destinationViewController];
        rvc.userDictionary = self.userDictionary;
        rvc.delegate = self;
    }
    
}

- (void)registrationCompleteForUser:(DBUser *)user
{
    [self.delegate logInDidFinishedLoading];
    [self hideActivityIndicator];
}


#pragma mark - Activity Indicator Methods
- (void) showActivityIndicator
{
    self.logInEmailTextField.userInteractionEnabled = NO;
    self.logInPasswordTextField.userInteractionEnabled = NO;
    self.logInButton.userInteractionEnabled = NO;
    
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void) hideActivityIndicator
{
    self.logInEmailTextField.userInteractionEnabled = YES;
    self.logInPasswordTextField.userInteractionEnabled = YES;
    self.logInButton.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    
    [self.activityIndicatorView stopAnimating];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.logInEmailTextField) {
        [self.logInPasswordTextField becomeFirstResponder];
    }else if (textField == self.logInPasswordTextField){
        [self login];
    }
    return NO;
}

#pragma mark - FacebookManager Delegate Methods
- (void)onUserLoggedIn
{
    [[FacebookManager sharedInstance] requestUserInfo];
}

- (void)onUserLoggedOut
{
    
}


- (void)onUserInfoRequestComplete:(NSDictionary <FBGraphUser> *) userInfo
{
    self.userDictionary = [[NSMutableDictionary alloc] init];
    self.userDictionary[kUserFullName] = userInfo.name;
    self.userDictionary[kUserFirstName] = userInfo.first_name;
    self.userDictionary[kUserLastName] = userInfo.last_name;
    if (userInfo.birthday) {
        self.userDictionary[kUserBirthDate] = userInfo.birthday;
    }
    if ([userInfo objectForKey:@"email"]) {
        self.userDictionary[kUserEmail] = userInfo[@"email"];
    }
    self.userDictionary[kUserFacebookID] = userInfo.objectID;
    NSString* imageURL = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", userInfo.objectID];
    self.userDictionary[kUserImageURL] = imageURL;
    
    [self socialLogin];
}

- (void)onPermissionsDeclined:(NSArray *)declinedPermissions
{
    
    
}

#pragma mark - Facebook Login

- (void)socialLogin {
    {
        [InkitService logInSocialDictionary:self.userDictionary withTarget:self completeAction:@selector(socialLogInUserComplete) completeError:@selector(socialLogInUserError:)];
        [self showActivityIndicator];
    }
}

- (void)socialLogInUserComplete {
    [self.delegate logInDidFinishedLoading];
    [self hideActivityIndicator];
}

- (void)socialLogInUserError:(NSString *)errorMessage {
    if ([errorMessage isEqualToString:@"Social Network Id mismatch"]) {
        // set register window pero seteando el diccionario de datos
        [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
    }
}

#pragma mark - Google+ Delegate

- (IBAction)GoogleSignInButton:(id)sender {
    [[GPPSignIn sharedInstance] authenticate];
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // El usuario ha iniciado sesión.
        self.googleSignInButton.hidden = YES;
        // Lleva a cabo otras acciones aquí, como mostrar el botón de cierre de sesión
    } else {
        self.googleSignInButton.hidden = NO;
        // Lleva a cabo otras acciones aquí
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // El usuario ha cerrado sesión y se ha desconectado.
        // Borra los datos del usuario como especifican las condiciones de Google+.
    }
}
@end
