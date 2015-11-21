//
//  IKImage.m
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import "IKImage.h"
#include <SDWebImage/UIImageView+WebCache.h>

@implementation IKImage

+ (IKImage *)newImage {
    IKImage* image = [IKImage new];
    return image;
}

+ (IKImage *)fromURL:(NSString *)URLString {
    IKImage* image = [IKImage newImage];
    image.imageURL = URLString;
    return image;
}

+ (IKImage *)fromUIImage:(UIImage *)image {
    IKImage *inkImage = [IKImage newImage];
    inkImage.imageData = UIImagePNGRepresentation(image);
    return inkImage;
}

- (void)setInImageView:(UIImageView *)imageView {
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageData = UIImagePNGRepresentation(image);
    }];
}

@end
