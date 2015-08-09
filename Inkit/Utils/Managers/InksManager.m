//
//  InksManager.m
//  Inkit
//
//  Created by Cristian Pena on 8/8/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "InksManager.h"

@interface InksManager()

@property (strong, nonatomic) NSMutableArray *inksArray;
@property (nonatomic) NSUInteger currentPage;

@end

@implementation InksManager

- (DBInk *)inkAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.inksArray.count) {
        if (indexPath.row < ((NSArray *)self.inksArray[indexPath.section]).count) {
            return self.inksArray[indexPath.section][indexPath.row];
        }
    }
    return nil;
}

- (NSUInteger)numberOfInksForSection:(NSInteger)section {
    return ((NSArray *)self.inksArray[section]).count;
}

- (void)getMoreInks {

}

@end
