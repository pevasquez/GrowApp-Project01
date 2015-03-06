//
//  InkitDataUtil.h
//  Inkit
//
//  Created by Cristian Pena on 5/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBUser;

@interface InkitDataUtil : NSObject
@property (strong, nonatomic) DBUser* activeUser;
+ (InkitDataUtil*)sharedInstance;
@end
