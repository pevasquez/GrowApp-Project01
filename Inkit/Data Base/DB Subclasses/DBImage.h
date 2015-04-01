//
//  DBImage.h
//  Inkit
//
//  Created by María Verónica  Sonzini on 1/4/15.
//  Copyright (c) 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBInk, DBUser;

@interface DBImage : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) DBInk *ink;
@property (nonatomic, retain) DBUser *userPic;
@property (nonatomic, retain) DBUser *userPicThumbnail;

@end
