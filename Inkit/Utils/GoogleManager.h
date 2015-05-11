//
//  GoogleManager.h
//  Inkit
//
//  Created by Cristian Pena on 5/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleManagerDelegate <NSObject>
- (void)onGoogleUserLoggedOut;
- (void)onGoogleUserLoggedIn;
@optional
//- (void)onFacebookSessionStateChange:(FBSessionState*)fbSessionState;
- (void)onGoogleGoogleSessionError:(NSError*)fbError;
- (void)onGoogleGooglePermissionsGranted;
- (void)onGoogleGooglePermissionsDeclined:(NSArray *)declinedPermissions;
//- (void)onInviteRequestSuccess:(FBWebDialogResult *)fbResult andResultURL:(NSURL *)resultURL;
- (void)onGoogleInviteRequestError:(NSError*)fbError;
- (void)onGoogleUserFriendsRequestComplete:(NSArray *)userFriendInfo;
- (void)onGoogleUserFriendRequestError:(NSError*)fbError;
- (void)onGoogleUserInfoRequestError:(NSError*)fbError;
- (void)onGoogleUserInfoRequestComplete:(NSDictionary *)userInfo;
@end

@interface GoogleManager : NSObject

+ (GoogleManager*)sharedInstance;
@property (nonatomic, weak) id<GoogleManagerDelegate> delegate;

- (void)initializeGoogleSession;
- (void)requestUserInfo;
- (void)logInUser;
- (void)logOutUser;
@end
