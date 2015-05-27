//
//  FacebookManager.m
//  Inkit
//
//  Created by Cristian Pena on 1/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "FacebookManager.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface FacebookManager()
@property (strong, nonatomic) NSDictionary* userInfo;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSDictionary *dictFB;
@property (strong, nonatomic) ACAccountType *FBaccountType;
@property (strong, nonatomic) ACAccount *facebookAccount;
@end

@implementation FacebookManager

+ (id)sharedInstance
{
    static FacebookManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
    }
    return self;
}

- (void)initializeFacebookSession
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          if(!error) {
                                              [self sessionStateChanged:session state:state error:error];
                                          } else {
                                              [self.delegate onFacebookSessionError:error];
                                          }
                                      }];
    } else {
        [self.delegate onUserLoggedOut];
    }
}

- (void)internalLogInUser
{
    self.accountStore = [[ACAccountStore alloc]init];
    self.FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:
                                   ACAccountTypeIdentifierFacebook];
    
    NSDictionary *dictFB = @{ACFacebookAppIdKey : @"1410385759286626", ACFacebookPermissionsKey : [NSArray arrayWithObject:@"email"] };
    [self.accountStore requestAccessToAccountsWithType:self.FBaccountType options:dictFB
                                            completion: ^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    [self requestUserGraph];
//                                                    [self.delegate onInternalLoginSuccess];
                                                } else {
                                                    [self.delegate onInternalLoginError:error];
                                                } }];
}

- (void)requestUserGraph {
    
    NSArray *accounts = [self.accountStore accountsWithAccountType:self.FBaccountType];
    //it will always be the last object with SSO
    self.facebookAccount = [accounts lastObject];
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:nil];
    request.account = self.facebookAccount;
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {
        
        if(!error){
            NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions error:&error];
            NSLog(@"Dictionary contains: %@", list );
            [self.delegate onFacebookUserInfoRequestComplete:(NSDictionary <FBGraphUser> *)list];
        } else{
            
        }
        
    }];
}

- (void)sdkLogInUser {
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
}

- (void)closeFBSession:(BOOL)clearToken
{
    if (clearToken) {
        [FBSession.activeSession closeAndClearTokenInformation];
    } else {
        [FBSession.activeSession close];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (state == FBSessionStateClosedLoginFailed) {
        [session closeAndClearTokenInformation];
        [self.delegate onUserLoggedOut];
    } else if (state == FBSessionStateOpen || state == FBSessionStateOpenTokenExtended) {
        if ([self checkIfPermissionsGranted:session]) {
            [self requestUserInfo];
//            [self.delegate onUserLoggedIn];
        } else {
            [self.delegate onPermissionsDeclined:session.declinedPermissions];
        }
    } else if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        [session closeAndClearTokenInformation];
        [self.delegate onUserLoggedOut];
        
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertText = [FBErrorUtility userMessageForError:error];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                NSLog(@"%@%@",alertTitle, alertText);
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                NSLog(@"%@%@",alertTitle, alertText);
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

- (BOOL)isFacebookSessionOpen
{
    return FBSession.activeSession.isOpen;
}

- (BOOL)checkIfPermissionsGranted:(FBSession *)session
{
    if ([session.permissions containsObject:@"email"] && [session.permissions containsObject:@"public_profile"]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)requestUserInfo
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (error) {
                 [self.delegate onUserInfoRequestError:error];
             } else {
                 self.userInfo = user;
                 [self.delegate onFacebookUserInfoRequestComplete:self.userInfo];
             }
         }];
    }
}

- (NSDictionary *)getCachedUserInfo
{
    return self.userInfo;
}

@end
