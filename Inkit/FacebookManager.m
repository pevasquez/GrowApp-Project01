//
//  FacebookManager.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 1/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "FacebookManager.h"

@interface FacebookManager()
@property (strong, nonatomic) NSDictionary* userInfo;
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
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"]
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

- (void)logInUser
{
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_birthday"]
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
            [self.delegate onUserLoggedIn];
            //[self userLoggedInToFacebook];
        } else {
            [self.delegate onPermissionsDeclined:session.declinedPermissions];
        }
    } else if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
        [session closeAndClearTokenInformation];
        [self.delegate onUserLoggedOut];
        //[self userLoggedOut];
        
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
    if ([session.permissions containsObject:@"email"] && [session.permissions containsObject:@"public_profile"] && [session.permissions containsObject:@"user_birthday"]) {
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
                 [self.delegate onUserInfoRequestComplete:self.userInfo];
             }
         }];
    }
}

- (NSDictionary *)getCachedUserInfo
{
    return self.userInfo;
}

@end
