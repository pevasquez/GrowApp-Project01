//
//  IKImage.h
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKImage : NSObject

@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, retain) NSData * imageData;

+ (IKImage *)fromURL:(NSString *)URLString;
+ (IKImage *)fromUIImage:(UIImage *)image;
- (void)setInImageView:(UIImageView *)imageView;
- (void)setInImage:(UIImage *)image;
- (UIImage *)getImage;

@end
