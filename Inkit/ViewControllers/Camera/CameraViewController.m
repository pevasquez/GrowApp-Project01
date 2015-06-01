//
//  CameraViewController.m
//  Inkit
//
//  Created by Cristian Pena on 9/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "CameraViewController.h"
#import "InkitTabBarController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import "EditImageViewController.h"

@interface CameraViewController() <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    // Audio Video Capture
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *prevLayer;
    
    // Media Browser
    UIImagePickerController *mediaUI;
}

@property (weak, nonatomic) IBOutlet UIView *prevLayerView;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIImageView *prevImageView;
@property (strong, nonatomic) UIImage *inkImage;

@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraRollButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOkButton;

@property (nonatomic) BOOL isTakingPicture;
@end

@implementation CameraViewController

#pragma mark - Life cycle methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.stillImageOutput = nil;
    self.prevImageView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    [self stopCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startCamera];
}

#pragma mark - Camera Setup
- (void)startCamera
{
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input) {
        [session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.prevLayerView.frame;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:self.stillImageOutput];
    [session startRunning];
    
    self.isTakingPicture = YES;
}

- (void)stopCamera
{
    [session stopRunning];
    session = nil;
    input = nil;
    output = nil;
    self.isTakingPicture = NO;
}

- (void)captureImageFromCamera
{
    [self showFlashShot];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, (CFStringRef)@"{Exif}" , NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             //NSLog(@"attachements: %@", exifAttachments);
         }
         else
         {
             //NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.prevImageView.image = image;
         self.inkImage = image;
         [self stopCamera];
         
         [self goToNextWindow];
     }];
}

- (void)showFlashShot
{
    // Create a empty view with the color white.
    UIView *flashView = [[UIView alloc] initWithFrame:self.view.bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.alpha = 1.0;
    
    // Add the flash view to the window
    [self.view addSubview:flashView];
    
    // Fade it out and remove after animation.
    [UIView animateWithDuration:0.2 animations:^{
        flashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
        self.inkImage = imageToUse;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self goToNextWindow];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Image Browser Methods
-(void)startMediaBrowser
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                                        message:NSLocalizedString(@"The photo albums are not available",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Continue",nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

#pragma mark - Buttons Methods

- (IBAction)takePictureButtonPressed:(UIButton *)sender
{
    self.isTakingPicture = NO;
    [self captureImageFromCamera];
}

- (IBAction)showCameraRollButtonPressed:(UIButton *)sender
{
    self.isTakingPicture = NO;
    [self startMediaBrowser];
}

- (IBAction)cancelOkButtonPressed:(UIButton *)sender
{
    if (self.isTakingPicture) {
        InkitTabBarController* inkitTabBarController = (InkitTabBarController*)self.tabBarController;
        [inkitTabBarController selectLastSelectedItem];
    } else {
        [self setUpButtonsForStatus];
    }
    
}

- (void)setUpButtonsForStatus
{
    
}

#pragma mark - Navigation Methods
- (void)goToNextWindow
{
    [self performSegueWithIdentifier:@"EditImageSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"EditImageSegue"]) {
        EditImageViewController* editImageViewController = [segue destinationViewController];
        editImageViewController.imageToEdit = self.inkImage;
    }
}

#pragma mark - Overriden UIViewController methods
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
@end
