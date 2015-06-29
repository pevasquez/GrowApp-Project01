//
//  DBInk+Management.h
//  Inkit
//
//  Created by Cristian Pena on 6/2/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import "DBInk.h"
#import <UIKit/UIKit.h>
#import "InkitConstants.h"

@interface DBInk (Management)
+ (DBInk *)fromJson:(NSDictionary *)inkData;
- (void)updateWithJson:(NSDictionary *)inkData;
+ (DBInk *)inkWithInk:(DBInk *)ink;
+ (void)deleteInk:(DBInk *)ink completion:(ServiceResponse)completion;

- (UIImage *)getInkImage;
- (CGFloat)getImageAspectRatio;

- (NSString*)getBodyPartsAsString;
- (NSString *)getTattooTypesAsString;
- (NSString *)getArtistsAsString;

- (NSArray *)toArray;
- (NSDictionary *)toDictionary;
+ (NSDictionary *)emptyDictionary;

// Comment Actions
- (NSArray *)getCommentsSorted;
- (void)updateCommentsWithJson:(NSArray *)commentsArray;
@end
