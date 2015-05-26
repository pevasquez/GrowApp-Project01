//
//  NSMutableData+Extension.m
//  Inkit
//
//  Created by Cristian Pena on 5/13/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "NSData+Extension.h"
#import <UIKit/UIKit.h>

@implementation NSData (Extension)
+ (NSData *)fromDictionary:(NSDictionary *)dataDictionary andBoundary:(NSString *)boundary{
    NSMutableData *body = [NSMutableData data];
    NSArray* keysArray = [dataDictionary allKeys];
    for (NSString* key in keysArray) {
        if ([dataDictionary[key] isKindOfClass:[NSString class]]) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", dataDictionary[key]] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if ([dataDictionary[key] isKindOfClass:[UIImage class]]) {
            NSData* imageData = UIImageJPEGRepresentation(dataDictionary[key], 1.0);
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if ([dataDictionary[key] isKindOfClass:[NSArray class]]) {
            for (NSString* value in dataDictionary[key]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[]\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    return body;
}
@end
