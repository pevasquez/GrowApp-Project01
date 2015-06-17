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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

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

- (void)internalLogInUser
{
    self.accountStore = [[ACAccountStore alloc]init];
    self.FBaccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:
                          ACAccountTypeIdentifierFacebook];
    
    NSDictionary *dictFB = @{ACFacebookAppIdKey : @"1410385759286626", ACFacebookPermissionsKey : @[@"email", @"public_profile"] };
    [self.accountStore requestAccessToAccountsWithType:self.FBaccountType options:dictFB completion: ^(BOOL granted, NSError *error) {
        
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:self.FBaccountType];
            self.facebookAccount = [accounts lastObject];
            NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:requestURL parameters:nil];
            request.account = self.facebookAccount;
            [request performRequestWithHandler:^(NSData *data, NSHTTPURLResponse *response, NSError *error) {
                
                if(!error) {
                    NSDictionary *list =[NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions error:&error];
                    [self.delegate onFacebookUserInfoRequestComplete:(NSDictionary <FBGraphUser> *)list];
                } else {
                    [self.delegate onInternalLoginError:error];
                }
                
            }];
        } else {
            [self.delegate onInternalLoginError:error];
        } }];
}


- (void)sdkLogInUser {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email", @"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [self.delegate sdkLoginError:error];
        } else if (result.isCancelled) {
            [self.delegate sdkLoginCancelledByUser];
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             [self.delegate onFacebookUserInfoRequestComplete:(NSDictionary <FBGraphUser> *)result];
                         }
                     }];
                }
            }
        }
    }];
}

@end
