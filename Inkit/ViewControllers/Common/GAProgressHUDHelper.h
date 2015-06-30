//
//  GAHelper.h
//  GAActivityIndicator
//
//  Created by Cristian Pena on 24/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAProgressHUD.h"

@interface GAProgressHUDHelper : GAProgressHUD


+ (void)showSendingDataProgressHUDinView:(UIView *)view;
+ (void)showDownloadingDataProgressHUDinView:(UIView *)view;
+ (void)showUploadingDataProgressHUDinView:(UIView *)view;
+ (void)loggingInProgressHUDinView:(UIView *)view;
+ (void)registeringProgressHUDinView:(UIView *)view;
+ (void)browseProgressHUD:(UIView *)view;
+ (void)standarBlankHUD:(UIView *)view;
+ (void)creatingInkProgressHUD:(UIView *)view;
+ (void)logOutProgressHUD:(UIView *)view;
+ (void)postCommentHUDinView:(UIView *)view;
+ (void)hideProgressHUDinView:(UIView *)view;

@end
