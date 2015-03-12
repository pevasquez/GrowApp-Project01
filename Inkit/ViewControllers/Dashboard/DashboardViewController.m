//
//  DashboardViewController.m
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DashboardViewController.h"
//#import "CreateInkViewController.h"
#import "EditImageViewController.h"
#import "InkitButton.h"

@interface DashboardViewController () {
    UIImagePickerController *mediaUI;
}

@property (strong, nonatomic) UIImage *inkImage;


@property (weak, nonatomic) IBOutlet InkitButton *fromCameraButton;
@property (weak, nonatomic) IBOutlet InkitButton *fromAlbumButton;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpButtons];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)setUpButtons
{
    [self.fromCameraButton setTitle: NSLocalizedString(@"From\nCamera", nil) forState: UIControlStateNormal];
    [self.fromAlbumButton setTitle: NSLocalizedString(@"From\nAlbum",nil) forState: UIControlStateNormal];
    
    
    self.fromCameraButton.iconImage = [UIImage imageNamed:@"Dashboard-Camera"];
    self.fromAlbumButton.iconImage = [UIImage imageNamed:@"Dashboard-Album"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fromCameraButtonPressed:(UIButton *)sender
{
    [self startCameraControllerForPhoto];
}

- (IBAction)fromAlbumButtonPressed:(UIButton *)sender
{
    [self startMediaBrowser];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[EditImageViewController class]]) {
        EditImageViewController* editImageViewController = [segue destinationViewController];
        editImageViewController.imageToEdit = self.inkImage;
    }
//    if ([[segue destinationViewController] isKindOfClass:[CreateInkViewController class]]) {
//        CreateInkViewController* createViewController = [segue destinationViewController];
//        createViewController.inkImage = self.inkImage;
//    }
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

#pragma mark - Image Taking Methods

- (void)startCameraControllerForPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                                        message:NSLocalizedString(@"The camera is not available",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Continue",nil)
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    //cameraUI.
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    cameraUI.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:cameraUI animated:YES completion:nil];
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
    [self performSegueWithIdentifier:@"EditImageSegue" sender:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
