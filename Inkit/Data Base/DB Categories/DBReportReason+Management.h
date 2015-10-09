//
//  DBReportReason+Management.h
//  Inkit
//
//  Created by Cristian Pena on 10/8/15.
//  Copyright © 2015 Digbang. All rights reserved.
//

#import "DBReportReason.h"

@interface DBReportReason (Management)

+ (DBReportReason *)fromJson:(NSDictionary *)reportReasonDictionary;

// Get Body Parts
+ (NSArray *)getReportReasonsSorted;

@end
