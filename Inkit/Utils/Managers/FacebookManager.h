//
//  FacebookManager.h
//  Inkit
//
//  Created by Cristian Pena on 1/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol FacebookManagerDelegate <NSObject>
- (void)onUserLoggedOut;
- (void)onUserLoggedIn;
@optional
- (void)onFacebookSessionStateChange:(FBSessionState*)fbSessionState;
- (void)onFacebookSessionError:(NSError*)fbError;
- (void)onPermissionsGranted;
- (void)onPermissionsDeclined:(NSArray *)declinedPermissions;
- (void)onInviteRequestSuccess:(FBWebDialogResult *)fbResult andResultURL:(NSURL *)resultURL;
- (void)onInviteRequestError:(NSError*)fbError;
- (void)onUserFriendsRequestComplete:(NSArray *)userFriendInfo;
- (void)onUserFriendRequestError:(NSError*)fbError;
- (void)onUserInfoRequestError:(NSError*)fbError;
- (void)onFacebookUserInfoRequestComplete:(NSDictionary *)userInfo;
- (void)onInternalLoginError:(NSError *)error;
- (void)onInternalLoginSuccess;

// Nuevo SDK
- (void)sdkLoginCancelledByUser;
- (void)sdkLoginError:(NSError *)error;
@end


@interface FacebookManager : NSObject
+ (FacebookManager*)sharedInstance;
@property (nonatomic, weak) id<FacebookManagerDelegate> delegate;
- (void)sdkLogInUser;
- (void)internalLogInUser;
- (void)logOutUser;
@end

