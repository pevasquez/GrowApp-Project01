//
//  RWTViewController.m
//  CenteredImageScroller
//
//  Created by Main Account on 4/26/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "ViewImageViewController.h"
#import "CenteredScrollView.h"

@interface ViewImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) CenteredScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage:self.inkImage];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.tabBarController.tabBar setTranslucent:YES];
    
    self.scrollView = [[CenteredScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"%@", NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"%@", NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    NSLog(@"%@", NSStringFromCGPoint(self.scrollView.contentOffset));
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = self.imageView.bounds.size;
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.delegate = self;
    [self setZoomScales];
}

- (void)setZoomScales {

  CGSize boundsSize = self.scrollView.bounds.size;
  CGSize imageSize = self.imageView.bounds.size;
  
  CGFloat xScale = boundsSize.width / imageSize.width;
  CGFloat yScale = boundsSize.height / imageSize.height;
  CGFloat minScale = MIN(xScale, yScale);
  
  self.scrollView.minimumZoomScale = minScale;
  self.scrollView.zoomScale = minScale;
  self.scrollView.maximumZoomScale = 3.0;

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self setZoomScales];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tabBarController.tabBar setAlpha:0];
        [self.navigationController.navigationBar setAlpha:0];
        self.scrollView.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:false];
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    [UIView animateWithDuration:0.2 delay:0. options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.tabBarController.tabBar setAlpha:1];
        [self.navigationController.navigationBar setAlpha:1];
        self.scrollView.backgroundColor = [UIColor whiteColor];
    } completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

- (IBAction)tapHideUnhideBar:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
//    if (self.navigationController.navigationBar.hidden == NO) {
//        
//
//    } else if (self.navigationController.navigationBar.hidden == YES) {
//            }
}

@end
