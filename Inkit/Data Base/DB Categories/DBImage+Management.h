//
//  DBImage+Management.h
//  Inkit
//
//  Created by Cristian Pena on 1/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBImage.h"
#import <UIKit/UIKit.h>

typedef void (^ImageCompletion)(UIImage *image);

@interface DBImage (Management)
//+ (DBImage *)fromJson:(NSDictionary *)imageData;
+ (DBImage *)fromURL:(NSString *)URLString;
+ (DBImage *)fromUIImage:(UIImage *)image;
- (void)setInImageView:(UIImageView *)imageView;
- (void)setInImage:(UIImage *)image;
- (UIImage *)getImage;

@end
