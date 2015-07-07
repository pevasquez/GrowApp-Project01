//
//  NSString+Extensions.m
//  Inkit
//
//  Created by Cristian Pena on 7/7/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSString*)stringWithSentenceCapitalization {
    
    NSString *firstCharacterInString = [[self substringToIndex:1] capitalizedString];
    NSString *sentenceString = [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString: firstCharacterInString];
    
    return sentenceString;
}


@end
