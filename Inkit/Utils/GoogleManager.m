//
//  GoogleManager.m
//  Inkit
//
//  Created by Cristian Pena on 5/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "GoogleManager.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "InkitConstants.h"

@interface GoogleManager() <GPPSignInDelegate>
@property (strong, nonatomic) NSMutableDictionary* userInfo;
@end
@implementation GoogleManager

static NSString * const kClientId = @"696055674747-jc3jtik6usp6597ppqvosjh2te294l4o.apps.googleusercontent.com";

+ (id)sharedInstance
{
    static GoogleManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
        [self initializeGoogleSession];
    }
    return self;
}

- (void)initializeGoogleSession {
    GPPSignIn *googleSignIn = [GPPSignIn sharedInstance];
    googleSignIn.clientID = kClientId;
    googleSignIn.scopes = @[kGTLAuthScopePlusLogin];
    googleSignIn.shouldFetchGoogleUserEmail = YES;
    googleSignIn.delegate = self;
    
    [[GPPSignIn sharedInstance]trySilentAuthentication];
}

- (void)logInUser {
    [[GPPSignIn sharedInstance] authenticate];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if (error) {
        [self.delegate onGoogleGoogleSessionError:error];
    } else {
        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        [self requestUserInfo];
    }
}

- (void)requestUserInfo {
    // 1. Create a |GTLServicePlus| instance to send a request to Google+.
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
    plusService.retryEnabled = YES;
    
    // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    // *4. Use the "v1" version of the Google+ API.*
    plusService.apiVersion = @"v1";
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
                if (error) {
                    //Handle Error
                    [self.delegate onGoogleUserInfoRequestError:error];
                } else  {
                    NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
                    NSLog(@"GoogleID=%@",person.identifier);
                    NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
                    NSLog(@"Gender=%@",person.gender);
                    
                    self.userInfo = [[NSMutableDictionary alloc] init];
                    self.userInfo[kUserFirstName] = person.name.givenName;
                    self.userInfo[kUserLastName] = person.name.familyName;
                    self.userInfo[kUserEmail] = [GPPSignIn sharedInstance].authentication.userEmail;
                    self.userInfo[kUserExternalId] = person.identifier;
                    [self.delegate onGoogleUserInfoRequestComplete:self.userInfo];
                }
            }];

}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // El usuario ha cerrado sesión y se ha desconectado.
        // Borra los datos del usuario como especifican las condiciones de Google+.
        self.userInfo = nil;
    }
}

- (NSDictionary *)getCachedUserInfo
{
    return self.userInfo;
}

- (void)logOutUser {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
