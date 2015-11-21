//
//  IKBoard.h
//  Inkit
//
//  Created by Cristian Pena on 11/21/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IKInk, IKImage;

@interface IKBoard : NSObject

@property (nonatomic, strong) id boardCover;
@property (nonatomic, strong) NSString * boardDescription;
@property (nonatomic, strong) NSString * boardID;
@property (nonatomic, strong) NSString * boardTitle;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * updatedAt;
@property (nonatomic, strong) NSMutableArray *inks;
@property (nonatomic, strong) DBUser *user;

+ (IKBoard *)fromJson:(NSDictionary *)boardData;

- (void)updateWithDictionary:(NSDictionary *)boardDictionary Target:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)deleteWithTarget:(id)target completeAction:(SEL)completeAction completeError:(SEL)completeError;
- (void)getInksWithCompletion:(ServiceResponse)completion;

- (NSArray *)getInksFromBoard;

- (void)updateWithJson:(NSDictionary *)jsonDictionary;
- (void)updateInksWithJson:(NSDictionary *)jsonDictionary;
- (void)addInkToBoard:(IKInk *)ink;
- (void)addInksToBoard:(NSArray *)inksArray;
- (void)removeInkFromBoard:(DBInk *)ink;
- (void)removeInksFromBoard:(NSArray *)inksArray;
- (void)deleteBoard;

@end
