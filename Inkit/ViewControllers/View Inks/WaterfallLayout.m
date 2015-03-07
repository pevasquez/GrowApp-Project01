//
//  WaterfallLayout.m
//  Inkit
//
//  Created by Cristian Pena on 24/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "WaterfallLayout.h"

@implementation WaterfallLayout

#define numColumns 2

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        
        if (attributes.representedElementKind == nil) {
            
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
            
        }
        
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes* currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if (indexPath.item < numColumns) {
        
        CGRect frame = currentItemAttributes.frame;
        frame.origin.y = 5;
        currentItemAttributes.frame = frame;
        
        return currentItemAttributes;
        
    }
    
    NSIndexPath* indexPathPrev = [NSIndexPath indexPathForItem:indexPath.item-numColumns inSection:indexPath.section];
    CGRect framePrev = [self layoutAttributesForItemAtIndexPath:indexPathPrev].frame;
    CGFloat YPointNew = framePrev.origin.y + framePrev.size.height + 10;
    CGRect frame = currentItemAttributes.frame;
    frame.origin.y = YPointNew;
    currentItemAttributes.frame = frame;
    
    return currentItemAttributes;
}

@end
