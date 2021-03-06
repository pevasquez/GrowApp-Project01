//
//  TutorialPage.h
//  Tutorial
//
//  Created by Cristian Pena on 7/5/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TutorialPage : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, strong) NSString *text;

- (instancetype)initWithIndex:(int)index text:(NSString *)text;
- (UIImage *)bgImage;
- (UIImage *)iconImage;
+ (NSArray *)allPages;

@end
