//
//  DBImage.h
//  Inkit
//
//  Created by Cristian Pena on 4/12/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBUser;

@interface DBImage : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSSet *ink;
@property (nonatomic, retain) DBUser *userPic;
@property (nonatomic, retain) DBUser *userPicThumbnail;
@end

@interface DBImage (CoreDataGeneratedAccessors)

- (void)addInkObject:(DBInk *)value;
- (void)removeInkObject:(DBInk *)value;
- (void)addInk:(NSSet *)values;
- (void)removeInk:(NSSet *)values;

@end