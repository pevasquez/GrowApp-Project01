//
//  UIResponder+FirstResponder.m
//  Inkit
//
//  Created by Cristian Pena on 5/11/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)
+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
@end
