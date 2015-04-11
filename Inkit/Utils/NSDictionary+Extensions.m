//
//  NSDictionary+Extensions.m
//  Inkit
//
//  Created by Cristian Pena on 4/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

- (NSString *)serializeParams {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [self keyEnumerator]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *subKey in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)[value objectForKey:subKey],
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, escaped_value]];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            for (NSString *subValue in value) {
                NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)subValue,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, escaped_value]];
            }
        } else {
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                          (CFStringRef)[self objectForKey:key],
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}
@end
