//
//  GAHelper.m
//  GAActivityIndicator
//
//  Created by María Verónica  Sonzini on 24/5/15.
//  Copyright (c) 2015 María Verónica Sonzini. All rights reserved.
//

#import "GAProgressHUDHelper.h"

@implementation GAProgressHUDHelper

#pragma mark - Activity Indicator Methods

+ (void)showSendingDataProgressHUDinView:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Sending Data...";
}

+ (void)showDownloadingDataProgressHUDinView:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Downloading Data...";
}

+ (void)showUploadingDataProgressHUDinView:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Uploading Data...";
}

+ (void)loggingInProgressHUDinView:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Loggin in...";
}

+ (void)registeringProgressHUDinView:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Registering...";
}

+ (void)creatingInkProgressHUD:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Creating Ink...";
}

+ (void)browseProgressHUD:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Browsing...";
}

+ (void)standarBlankHUD:(UIView *)view
{
    [GAProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)logOutProgressHUD:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Baby come back...";
}

+ (void)postCommentHUDinView:(UIView *)view
{
    GAProgressHUD* hud = [GAProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Posting comment...";
}


#pragma mark - Hide Activity Indicator
+ (void)hideProgressHUDinView:(UIView *)view
{
    [GAProgressHUD hideHUDForView:view animated:true];
}




@end
