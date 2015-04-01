//
//  DBImage+Management.m
//  Inkit
//
//  Created by María Verónica  Sonzini on 1/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBImage+Management.h"
#import "DataManager.h"

@implementation DBImage (Management)
+ (DBImage *)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    DBImage* inkImage = [NSEntityDescription insertNewObjectForEntityForName:@"DBImage" inManagedObjectContext:managedObjectContext];
    
    return inkImage;
}

+ (DBImage *)fromURL:(NSString *)URLString
{
    DBImage *inkImage = [DBImage createInManagedObjectContext:[DataManager sharedInstance].managedObjectContext];
    inkImage.imageURL = URLString;
    return inkImage;
}

+ (DBImage *)fromUIImage:(UIImage *)image
{
    DBImage *inkImage = [DBImage createInManagedObjectContext:[DataManager sharedInstance].managedObjectContext];
    inkImage.imageData = UIImagePNGRepresentation(image);
    return inkImage;
}

- (void)setInImageView:(UIImageView *)imageView
{
    if (self.imageData) {
        imageView.image = [UIImage imageWithData:self.imageData];
    } else {
        dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
        dispatch_async(downloadQueue, ^{
            NSURL* url = [NSURL URLWithString:self.imageURL];
            NSData * imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageData = imageData;
                imageView.image = [UIImage imageWithData:self.imageData];
            });
        });
    }
}
@end
