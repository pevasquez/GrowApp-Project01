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

@interface LogInViewController () <RegisterDelegate>

@property (strong, nonatomic) IBOutlet UITextField *logInEmailTextField;

@property (strong, nonatomic) IBOutlet UITextField *logInPasswordTextField;
@property (strong, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInUserComplete
{
    [self.delegate logInDidFinishedLoading];
}

- (void)logInUserError:(NSString *)errorMessage
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)registerButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"RegisterSegue" sender:nil];
}

- (IBAction)logInButtonPressed:(id)sender {
    
    if([self verifyTextFields])
    {
        DBUser* user = [DBUser createNewUser];
        user.email = self.logInEmailTextField.text;
        user.password = self.logInPasswordTextField.text;
        [InkitService logInUser:user withTarget:self completeAction:@selector(logInUserComplete) completeError:@selector(logInUserError:)];
    }
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
        rvc.delegate = self;
    }
    
}

- (void)registrationCompleteForUser:(DBUser *)user
{
    [self.delegate logInDidFinishedLoading];
}

@end
