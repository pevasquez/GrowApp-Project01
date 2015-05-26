//
//  UIImage+Extension.m
//  Inkit
//
//  Created by Cristian Pena on 5/23/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)getSmallImage {
    return [self scaleProportionalToSize:CGSizeMake(self.size.width/4, self.size.height/4)];
}

- (UIImage *)getMediumImage {
    return [self scaleProportionalToSize:CGSizeMake(self.size.width/2, self.size.height/2)];
}

- (UIImage *)getLargeImage {
    return [self scaleProportionalToSize:CGSizeMake(self.size.width*0.75, self.size.height*0.75)];
}

- (UIImage *)scaleToSize:(CGSize)size
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(self.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (UIImage *)scaleProportionalToSize:(CGSize)size1
{
    if(self.size.width>self.size.height)
    {
        NSLog(@"LandScape");
        size1 = CGSizeMake((self.size.width/self.size.height)*size1.height,size1.height);
    }
    else
    {
        NSLog(@"Potrait");
        size1 = CGSizeMake(size1.width,(self.size.height/self.size.width)*size1.width);
    }
    
    return [self scaleToSize:size1];
}

@end
