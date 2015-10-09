//
//  DBReportReason.h
//  Inkit
//
//  Created by Cristian Pena on 10/8/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBReportReason : NSManagedObject

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *reportReasonId;

@end
