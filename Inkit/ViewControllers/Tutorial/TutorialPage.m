//
//  TutorialPage.m
//  Tutorial
//
//  Created by Cristian Pena on 7/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "TutorialPage.h"


@implementation TutorialPage

- (instancetype)initWithIndex:(int)index text:(NSString *)text {
    self = [super init];
    if (self) {
        _index = index;
        _text = text;
    }
    return self;
}

- (UIImage *)bgImage {
    return [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpg", self.index +1]];
}

- (UIImage *)iconImage {
    return [UIImage imageNamed:@"icon_tattoo.png"];
}

+ (NSArray *)allPages {
    TutorialPage *page0 = [[TutorialPage alloc]initWithIndex:0 text:@"Slide to Step 2"];
    TutorialPage *page1 = [[TutorialPage alloc]initWithIndex:1 text:@"Slide to Step 3"];
    TutorialPage *page2 = [[TutorialPage alloc]initWithIndex:2 text:@"Slide to Final Step"];
    TutorialPage *page3 = [[TutorialPage alloc]initWithIndex:3 text:@"Start Using Inkit!"];
    
    return @[page0, page1, page2, page3];
}
@end
