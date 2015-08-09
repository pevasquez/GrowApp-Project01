//
//  InksManager.h
//  Inkit
//
//  Created by Cristian Pena on 8/8/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InksManager : NSObject

- (DBInk *)inkAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfInksForSection:(NSInteger)section;

@end
