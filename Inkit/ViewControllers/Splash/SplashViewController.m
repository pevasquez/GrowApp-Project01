//
//  SplashViewController.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SplashViewController.h"
#import "DBUser.h"

@interface SplashViewController ()

@property (nonatomic) BOOL userLoggedComplete;
@property (nonatomic) BOOL bodyPartsGetComplete;
@property (nonatomic) BOOL tattooTypesGetComplete;
@property (nonatomic) BOOL reportReasonsGetComplete;

@end

@implementation SplashViewController

#pragma mark - LifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InkitService getBodyPartsWithCompletion:^(id response, NSError *error) {
        self.bodyPartsGetComplete = error == nil;
        [self splashScreenDidFinishedLoading];
    }];
    [InkitService getTattooTypesWithCompletion:^(id response, NSError *error) {
        self.tattooTypesGetComplete = error == nil;
        [self splashScreenDidFinishedLoading];
    }];
    [InkitService getReportReasons:^(id response, NSError *error) {
        self.reportReasonsGetComplete = error == nil;
        [self splashScreenDidFinishedLoading];
    }];
}

- (void)splashScreenDidFinishedLoading {
    if (self.bodyPartsGetComplete && self.tattooTypesGetComplete && self.reportReasonsGetComplete) {
        [self.delegate splashScreenDidFinishedLoading];
    } else if (self.bodyPartsGetComplete == false && self.tattooTypesGetComplete == false && self.reportReasonsGetComplete == false) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You are not connected to the internet.Try again later." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Login
- (void)logInUserComplete {
    self.userLoggedComplete = YES;
    [self splashScreenDidFinishedLoading];
}

- (void)logInUserError {
    [self.delegate splashScreenDidFailToLogUser];
}

@end
