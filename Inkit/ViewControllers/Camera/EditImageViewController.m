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

@property (weak, nonatomic) IBOutlet UIView *editingView;
@property (weak, nonatomic) IBOutlet UIView *editContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *customEditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cropImageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) CropView *cropView;
@property (nonatomic) BOOL isCropping;

@end

@implementation EditImageViewController

#pragma mark - Life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    if (self.isEditing) {
        [self.continueButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    }
    self.editingView.clipsToBounds = true;
    self.customEditImageView.image = self.imageToEdit;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Actions

- (IBAction)rotateButtonPressed:(id)sender {
    [self rotate];
}

- (IBAction)cropButtonPressed:(id)sender {
    [self crop];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueButtonPressed:(UIButton *)sender {
    if (self.cropView.superview) {
        [self cropImage];
    }
    if (self.isEditing) {
        [self.delegate didEditImage:[self getEditedImage]];
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self performSegueWithIdentifier:@"CreateInkSegue" sender:nil];
    }
}

- (CGRect)getCanvasForCropView {
    return [self getFrameOfImageOfImageView:self.customEditImageView];
}

- (void)updateContainerView {
    self.editContainerView.frame = [self getCanvasForCropView];
    [self.cropView updateBounds];
}

- (void)rotate {
    // Si la orientacion es Top --> Left
    if (self.customEditImageView.image.imageOrientation == UIImageOrientationUp) {
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationLeft];
        self.cropImageView.image = [UIImage imageWithCGImage:self.cropImageView.image.CGImage scale:1 orientation:UIImageOrientationLeft];
    
    } else if (self.customEditImageView.image.imageOrientation == UIImageOrientationLeft) {
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationDown];
        self.cropImageView.image = [UIImage imageWithCGImage:self.cropImageView.image.CGImage scale:1 orientation:UIImageOrientationDown];
        
    } else if (self.customEditImageView.image.imageOrientation == UIImageOrientationDown){
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationRight];
        self.cropImageView.image = [UIImage imageWithCGImage:self.cropImageView.image.CGImage scale:1 orientation:UIImageOrientationRight];
        
    } else if (self.customEditImageView.image.imageOrientation == UIImageOrientationRight){
        self.customEditImageView.image = [UIImage imageWithCGImage:self.customEditImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];
        self.cropImageView.image = [UIImage imageWithCGImage:self.cropImageView.image.CGImage scale:1 orientation:UIImageOrientationUp];

    }
    [self updateContainerView];
}

- (void)crop {
    if (self.cropView.superview) {
        [self cropImage];
        [self removeCropView];
    } else {
        [self showCropView];
    }
}

- (void)showCropView {
    [self updateContainerView];
    if (self.cropView) {
        self.customEditImageView.hidden = false;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.customEditImageView.alpha = 1;
        } completion:^(BOOL finished) {
            self.cropImageView.hidden = true;
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.customEditImageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.cropView = [[CropView alloc] initWithFrame:self.editContainerView.bounds];
                [self.editContainerView addSubview:self.cropView];
            }];
        }];
    } else {
        self.cropView = [[CropView alloc] initWithFrame:self.editContainerView.bounds];
        [self.editContainerView addSubview:self.cropView];
    }
}

- (void)removeCropView {
    [self.cropView removeFromSuperview];
}

- (void)cropImage {
    UIImage *newImage = nil;
    
    CGSize sourceImageSize = self.customEditImageView.image.size;
    CGSize editSize = self.editContainerView.frame.size;
    CGFloat scale = sourceImageSize.width/editSize.width;
    
    CGSize cropSize = self.cropView.frame.size;
    CGFloat targetWidth = cropSize.width * scale;
    CGFloat targetHeight = cropSize.height * scale;
    CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
    
    CGFloat targetOriginX =  - self.cropView.frame.origin.x * scale;
    CGFloat targetOriginY = - self.cropView.frame.origin.y * scale;
    CGPoint targetOrigin = CGPointMake(targetOriginX, targetOriginY);
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect targetRect = CGRectZero;
    targetRect.origin = targetOrigin;
    targetRect.size = sourceImageSize;
    
    [self.customEditImageView.image drawInRect:targetRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");

    self.cropImageView.image = newImage;
    
    // Animate transition
    CGRect cropViewFrame = [self.editingView convertRect:self.cropView.frame fromView:self.editContainerView];
    CGRect destinyFrame = [self getFrameOfImageOfImageView:self.cropImageView];
    CGFloat animationScale = MIN(destinyFrame.size.width/cropViewFrame.size.width, destinyFrame.size.height/cropViewFrame.size.height);
    CGFloat traslationX = - (cropViewFrame.origin.x + cropViewFrame.size.width / 2) + (destinyFrame.origin.x + destinyFrame.size.width / 2);
    CGFloat traslationY = - (cropViewFrame.origin.y + cropViewFrame.size.height / 2) + (destinyFrame.origin.y + destinyFrame.size.height / 2);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(animationScale, animationScale);
        CGAffineTransform traslation = CGAffineTransformMakeTranslation(traslationX*animationScale, traslationY*animationScale);
        self.customEditImageView.transform = CGAffineTransformConcat(scaleTransform, traslation);
    } completion:^(BOOL finished) {
        self.cropImageView.hidden = false;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.customEditImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.customEditImageView.hidden = true;
        }];
    }];
}

- (UIImage *)getEditedImage {
    if (self.cropImageView.image) {
        return self.cropImageView.image;
    } else {
        return self.customEditImageView.image;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue destinationViewController] isKindOfClass:[CreateInkViewController class]]) {
        CreateInkViewController* createViewController = [segue destinationViewController];
        createViewController.inkImage = [self getEditedImage];
    }
}

#pragma mark - helper methods
- (CGRect)getFrameOfImageOfImageView:(UIImageView *)imageView {
    CGSize imageSize = imageView.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(imageView.bounds)/imageSize.width, CGRectGetHeight(imageView.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(imageView.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(imageView.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
    return imageFrame;
}

@end
