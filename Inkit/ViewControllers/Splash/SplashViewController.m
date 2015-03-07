//
//  SplashViewController.m
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "SplashViewController.h"
#import "InkitDataUtil.h"
#import "InkitService.h"
#import "DBUser.h"

@interface SplashViewController ()
@property (nonatomic) BOOL UserLoggedComplete;
@property (nonatomic) BOOL BodyPartsGetComplete;
@property (nonatomic) BOOL TattooTypesGetComplete;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InkitService logInUserWithToken:[InkitDataUtil sharedInstance].activeUser.token WithTarget:self completeAction:@selector(logInUserComplete) completeError:@selector(logInUserError)];
    [InkitService getBodyPartsWithTarget:self completeAction:@selector(getBodyPartsComplete) completeError:@selector(getBodyPartsError)];
    [InkitService getTattooTypesWithTarget:self completeAction:@selector(getTattooTypesComplete) completeError:@selector(getTattooTypesError)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)splashScreenDidFinishedLoading
{
    if (self.UserLoggedComplete && self.BodyPartsGetComplete && self.TattooTypesGetComplete) {
        [self.delegate splashScreenDidFinishedLoading];
    }
}

#pragma mark - Inkit Service Actions
- (void)getBodyPartsComplete
{
    self.BodyPartsGetComplete = YES;
    [self splashScreenDidFinishedLoading];
}

- (void)getBodyPartsError
{
    
}

- (void)getTattooTypesComplete
{
    self.TattooTypesGetComplete = YES;
    [self splashScreenDidFinishedLoading];
}

- (void)getTattooTypesError
{
    
}

- (void)logInUserComplete
{
    self.UserLoggedComplete = YES;
    [self splashScreenDidFinishedLoading];
}

- (void)logInUserError
{
    [self.delegate splashScreenDidFailToLogUser];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
