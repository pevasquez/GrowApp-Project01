//
//  DBImage+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 1/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBImage+Management.h"
#import "InkitTheme.h"
#import "DataManager.h"
#import "InkitConstants.h"

@implementation DBImage (Management)
+ (DBImage *)newImage
{
    DBImage* image = (DBImage *)[[DataManager sharedInstance] insert:kDBImage];
    // configure image
    return image;
}

+ (DBImage *)withURL:(NSString *)imageURL
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"imageURL = %@",imageURL];
    return (DBImage *)[[DataManager sharedInstance] first:kDBImage predicate:predicate sort:nil limit:1];
}

+ (DBImage *)fromURL:(NSString *)URLString
{
    DBImage* obj = [DBImage withURL:URLString];
    DBImage* image = nil;
    if (!obj) {
        image = [DBImage newImage];
    } else {
        image = obj;
    }
    image.imageURL = URLString;
    return image;
}

+ (DBImage *)fromUIImage:(UIImage *)image
{
    DBImage *inkImage = [DBImage newImage];
    inkImage.imageData = UIImagePNGRepresentation(image);
    return inkImage;
}


- (void)setInImageView:(UIImageView *)imageView
{
    if (self.imageData) {
        imageView.image = [UIImage imageWithData:self.imageData];
    } else {
        [imageView layoutIfNeeded];
        UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] init];
        
        activityIndicator.center = imageView.center;
        activityIndicator.color = [InkitTheme getTintColor];
        [imageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
        dispatch_async(downloadQueue, ^{
            NSURL* url = [NSURL URLWithString:self.imageURL];
            NSData * imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                self.imageData = imageData;
                imageView.image = [UIImage imageWithData:self.imageData];
                [[NSNotificationCenter defaultCenter] postNotificationName:DBNotificationImageUpdate object:nil userInfo:@{kDBImage:self}];
            });
        });
    }
}

- (void)setInImage:(UIImage *)image
{
    __block UIImage *localImage = image;
    if (self.imageData) {
        image = [UIImage imageWithData:self.imageData];
    } else {
        dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
        dispatch_async(downloadQueue, ^{
            NSURL* url = [NSURL URLWithString:self.imageURL];
            NSData * imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageData = imageData;
                localImage = [UIImage imageWithData:self.imageData];
            });
        });
    }
}

- (UIImage *)getImage
{
    return [UIImage imageWithData:self.imageData];
}
@end
