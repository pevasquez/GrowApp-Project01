//
//  EditImageViewController.m
//  Inkit
//
//  Created by Cristian Pena on 3/3/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "EditImageViewController.h"
#import "CreateInkViewController.h"

@interface EditImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *customEditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cropImageView;
@property (weak, nonatomic) IBOutlet CropView *cropView;
@end

@implementation EditImageViewController



#pragma mark - Life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cropView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.customEditImageView.image = self.imageToEdit;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)rotateButtonPressed:(id)sender
{
    // Si la orientacion es Top --> Right
    if (self.customEditImageView.image.imageOrientation == UIImageOrientationUp) {
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationRight];
        
    } else if (self.customEditImageView.image.imageOrientation == UIImageOrientationRight) {
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationDown];
                                          
    }else if (self.customEditImageView.image.imageOrientation == UIImageOrientationDown){
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationLeft];
                                          
    }else if (self.customEditImageView.image.imageOrientation == UIImageOrientationLeft){
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];
    }
}

- (IBAction)cropButtonPressed:(id)sender
{
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"CreateInkSegue" sender:nil];
}


#pragma mark - Crop View Delegate
- (BOOL)view:(UIView*)view willPanOutsideRect:(CGRect)rect withTranslation:(CGPoint)translation
{
    CGPoint viewOrigin = view.frame.origin;
    CGSize viewSize = view.frame.size;
    CGPoint boundsOrigin = rect.origin;
    CGSize boundsSize = rect.size;
    
    if ((viewOrigin.x + translation.x) < boundsOrigin.x)
        return NO;
    else if ((viewOrigin.y + translation.y) < boundsOrigin.y)
        return NO;
    else if ((viewSize.width + viewOrigin.x + translation.x) > (boundsOrigin.x + boundsSize.width))
        return NO;
    else if ((viewSize.height + viewOrigin.y + translation.y) > (boundsSize.height + boundsOrigin.y))
        return NO;
    return YES;
}

- (BOOL)view:(UIView*)view willScaleOutsideRect:(CGRect)rect withTranslation:(CGPoint)translation
{
    return NO;
}

- (CGRect)getCanvasForCropView
{
    return [self getFrameOfImageOfImageView:self.customEditImageView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[CreateInkViewController class]]) {
        CreateInkViewController* createViewController = [segue destinationViewController];
        createViewController.inkImage = self.customEditImageView.image;
    }
}

#pragma mark - helper methods
- (CGRect)getFrameOfImageOfImageView:(UIImageView *)imageView
{
    CGSize imageSize = imageView.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(imageView.bounds)/imageSize.width, CGRectGetHeight(imageView.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(imageView.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(imageView.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
    return imageFrame;
}

@end
